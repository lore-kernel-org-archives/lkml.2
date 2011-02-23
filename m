Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1BWBHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:07:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1BWBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:07:44 -0500
MIME-Version: 1.0
In-Reply-To: <4D645578.3020906@wytron.com.tw>
References: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
 <20110223001252.GT15795@trinity.fluff.org> <4D645578.3020906@wytron.com.tw>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 18:07:24 -0700
X-Google-Sender-Auth: 6yTykOsVM5hD7OFanD53y_jMqdM
Message-ID: <AANLkTikCHJoF-KHThge15fCQgsepjpUFdYtUzVpLk6fk@mail.gmail.com>
Subject: Re: [PATCH] i2c-ocores: register devices on child nodes
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Ben Dooks <ben-i2c@fluff.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 5:31 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> On 02/23/2011 08:12 AM, Ben Dooks wrote:
>>
>> On Thu, Feb 10, 2011 at 10:51:54AM +0800, Thomas Chou wrote:
>>>
>>> This patch registers devices on the devicetree child nodes to the bus.
>>> Also removes one trailing whitespace.
>>
>> Is this required as an urgent fix, or can it queue for next merge window?
>
> It is not urgent. An it is fine to queue it for next merge window.

Yes, queue for .39

g.

>
> - Thomas
>
>>
>>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>>> ---
>>>  drivers/i2c/busses/i2c-ocores.c |    6 +++++-
>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-ocores.c
>>> b/drivers/i2c/busses/i2c-ocores.c
>>> index ef3bcb1..c63838f 100644
>>> --- a/drivers/i2c/busses/i2c-ocores.c
>>> +++ b/drivers/i2c/busses/i2c-ocores.c
>>> @@ -18,7 +18,7 @@
>>>   * - interrupts      : interrupt number
>>>   * - regstep         : size of device registers in bytes
>>>   * - clock-frequency : frequency of bus clock in Hz
>>> - *
>>> + *
>>>   * Example:
>>>   *
>>>   *  i2c0: ocores@a0000000 {
>>> @@ -55,6 +55,7 @@
>>>  #include<linux/i2c-ocores.h>
>>>  #include<linux/slab.h>
>>>  #include<linux/io.h>
>>> +#include<linux/of_i2c.h>
>>>
>>>  struct ocores_i2c {
>>>        void __iomem *base;
>>> @@ -347,6 +348,9 @@ static int __devinit ocores_i2c_probe(struct
>>> platform_device *pdev)
>>>                        i2c_new_device(&i2c->adap, pdata->devices + i);
>>>        }
>>>
>>> +       /* Now register all the child nodes */
>>> +       of_i2c_register_devices(&i2c->adap);
>>> +
>>>        return 0;
>>>  }
>>>
>>> --
>>> 1.7.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
