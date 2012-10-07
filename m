Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2JGVwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:52:46 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54886 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2JGVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:52:44 -0400
Message-ID: <5071F9A6.9090701@gmail.com>
Date: Mon, 08 Oct 2012 08:52:38 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: walter harms <wharms@bfs.de>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for i2c_msg
 initialization
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr> <5071AEF3.6080108@bfs.de> <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/12 03:44, Julia Lawall wrote:
> On Sun, 7 Oct 2012, walter harms wrote:
> 
>>
>>
>> Am 07.10.2012 17:38, schrieb Julia Lawall:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>>
>>> In the second i2c_msg structure, a length expressed as an explicit
>>> constant
>>> is also re-expressed as the size of the buffer, reg.
>>>
>>> A simplified version of the semantic patch that makes this change is as
>>> follows: (http://coccinelle.lip6.fr/)
>>>
>>> // <smpl>
>>> @@
>>> expression a,b,c;
>>> identifier x;
>>> @@
>>>
>>> struct i2c_msg x =
>>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
>>> + I2C_MSG_READ(a,b,c)
>>>  ;
>>>
>>> @@
>>> expression a,b,c;
>>> identifier x;
>>> @@
>>>
>>> struct i2c_msg x =
>>> - {.addr = a, .buf = b, .len = c, .flags = 0}
>>> + I2C_MSG_WRITE(a,b,c)
>>>  ;
>>>
>>> @@
>>> expression a,b,c,d;
>>> identifier x;
>>> @@
>>>
>>> struct i2c_msg x =
>>> - {.addr = a, .buf = b, .len = c, .flags = d}
>>> + I2C_MSG_OP(a,b,c,d)
>>>  ;
>>> // </smpl>
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> ---
>>>  drivers/media/tuners/e4000.c |   20 +++-----------------
>>>  1 file changed, 3 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
>>> index 1b33ed3..8f182fc 100644
>>> --- a/drivers/media/tuners/e4000.c
>>> +++ b/drivers/media/tuners/e4000.c
>>> @@ -26,12 +26,7 @@ static int e4000_wr_regs(struct e4000_priv *priv,
>>> u8 reg, u8 *val, int len)
>>>      int ret;
>>>      u8 buf[1 + len];
>>>      struct i2c_msg msg[1] = {
>>> -        {
>>> -            .addr = priv->cfg->i2c_addr,
>>> -            .flags = 0,
>>> -            .len = sizeof(buf),
>>> -            .buf = buf,
>>> -        }
>>> +        I2C_MSG_WRITE(priv->cfg->i2c_addr, buf, sizeof(buf))
>>>      };
>>>
>>
>> Any reason why struct i2c_msg is an array ?
> 
> I assumed that it looked more harmonious with the other uses of
> i2c_transfer, which takes as arguments an array and the number of elements.
> 
> But there are some files that instead use i2c_transfer(priv->i2c, &msg, 1).
> I can change them all to do that if that is preferred.  But maybe I will
> wait a little bit to see if there are other issues to address at the
> same time.

This is probably a good thing to do, but the initial patch series should
just do the conversion to the macros. Too many additional changes runs
the risk of introducing bugs and making bisection difficult.

~Ryan

