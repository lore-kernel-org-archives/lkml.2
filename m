Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab2JHFFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:05:47 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:37305
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899Ab2JHFFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:05:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,549,1344204000"; 
   d="scan'208";a="158198354"
Date: Mon, 8 Oct 2012 07:05:27 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Ryan Mallon <rmallon@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/13] drivers/media/tuners/qt1010.c: use macros for
 i2c_msg initialization
In-Reply-To: <5071FA5D.30003@gmail.com>
Message-ID: <alpine.DEB.2.02.1210080704440.1972@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-5-git-send-email-Julia.Lawall@lip6.fr> <5071FA5D.30003@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, Ryan Mallon wrote:

> On 08/10/12 02:38, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>
>> A length expressed as an explicit constant is also re-expressed as the size
>> of the buffer, when this is possible.
>>
>> A simplified version of the semantic patch that makes this change is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression a,b,c;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
>> + I2C_MSG_READ(a,b,c)
>>  ;
>>
>> @@
>> expression a,b,c;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = 0}
>> + I2C_MSG_WRITE(a,b,c)
>>  ;
>>
>> @@
>> expression a,b,c,d;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = d}
>> + I2C_MSG_OP(a,b,c,d)
>>  ;
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/media/tuners/qt1010.c |   10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
>> index bc419f8..37ff254 100644
>> --- a/drivers/media/tuners/qt1010.c
>> +++ b/drivers/media/tuners/qt1010.c
>> @@ -25,10 +25,8 @@
>>  static int qt1010_readreg(struct qt1010_priv *priv, u8 reg, u8 *val)
>>  {
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->cfg->i2c_address,
>> -		  .flags = 0, .buf = &reg, .len = 1 },
>> -		{ .addr = priv->cfg->i2c_address,
>> -		  .flags = I2C_M_RD, .buf = val, .len = 1 },
>> +		I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->cfg->i2c_address, val, 1),
>
> This is a bit inconsistent. For single length values we should either
> consistently use sizeof(val) or 1. This has both.

val is a pointer.  It does not have size 1.

julia
