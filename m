Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1JRPSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:18:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52993 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1JRPSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:18:48 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D843A.5020001@cam.ac.uk>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
 <1318939596-27330-5-git-send-email-ricardo.ribalda@gmail.com>
 <4E9D7BD2.8090101@cam.ac.uk> <CAPybu_0kxqfo9Lx9V_oOXfBjOG2dnR0NLCV6=PM6cnUYmVb_iQ@mail.gmail.com>
 <4E9D843A.5020001@cam.ac.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 18 Oct 2011 17:18:07 +0200
Message-ID: <CAPybu_1epNidGGrn7FKVCF78wvUBvNPScaMCz2L1Pb4DJ82DEg@mail.gmail.com>
Subject: Re: [PATCHv2 4/7] input/cma3000_d0x: Add CMA3000 spi support
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan

 I have separated the read and write commands... but when I was
implementing the spi_write I found that most of the drivers just use
stack variables for spi_write. Like drivers/hwmon/ads7871.c,
drivers/gpio/max7301.c and others... Am I missing something or it is a
general "bug"?

As you say, it is better to not rewrite the cma3000 driver until
Hemanth says so, lets leave it for a future patch.




On Tue, Oct 18, 2011 at 15:50, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 10/18/11 14:43, Ricardo Ribalda Delgado wrote:
>> Hello Jonathan
>>
>>   First of all, thanks for your messages :).
>>
>>> To make my point about these functions being more complex than needed
>>> in more detail....
>>>
>>> If this were two functions and you drop the zero and 1 mask
>>> (which I'm not convinced make any sense. I've also killed the message.
>>> We both agree it is the wrong way to go, so post a patch fixing the i2c
>>> interface as well.
>>
>> Of course your functions are much more simpler and beautiful than the
>> fat one I wrote, no doubt about it :). Just three comments
>>
>> - Checking the one mask and the zero mask is the only way we have to
>> know if the chip is still there, The absense of that reply should
>> trigger an IO error or at least a retry. As you point out, the
>> zero/one mask is only violated on startup.  I just wanted to make it
>> more risk free, but if you believe it is more clear that way, lets
>> remove it
> It's somewhat unconventional to verify the existence of a chip like this.
> Usually you assume that if it was there once it still is unless there
> is a very good reason to think otherwise.  Worth doing an initial check
> in your spi_probe and indeed verify there against these known bits.
> No need to do it every time though.
>>
>> - I am not very fun of kmallocing data per write, specially when it is
>> part of the irq handler, and you expect this to be low latency. What
>> about allocating a buffer on init time, and use it with a mutex?
> That's absolutely fine and the right way to do it. You could poke it
> into the cma3000_accl_data then use the cachline aligned magic. Its
> is tiny so I doubt anyone will mind the overhead for the i2c side of
> things.
>>
>> -I dont like the push error message to the bottom, but that will mean
>> a rewrite of the cma3000 driver, shall I go for it?
> I would. Though probably worth getting Hemanth to say if he minds first
> given it's his driver!
>>
>>
>> Thanks again, and  I will post the new version when you reply this :)
>>
>>
>
>



-- 
Ricardo Ribalda
