Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0GBHUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:20:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57229 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0GBHUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=P6Jw8SKEPcru3x8oY3gzkb/NoRaQDQslCdqyyNabNne9nyt1Ps6fbT1DQgv5YWz6UW
         rtf7W94g6pk7Z+kOXmYcRt8iiqvQ/jHl01ArAZnt8+seNjwZMZW+fxbm/YYxgf0T+TtP
         wRUagTumWK/qcLxwN274JNGUyBKHPAW7GVsno=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100702061958.GA3691@core.coreip.homeip.net>
References: <1278034977.24246.6.camel@mola> <20100702061958.GA3691@core.coreip.homeip.net>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 2 Jul 2010 15:20:03 +0800
Message-ID: <AANLkTim-bc7PfauAU-agGcX56AhziaU41uw2OoP9tvAQ@mail.gmail.com>
Subject: Re: [PATCH] fujitsu-laptop: remove unnecessary input_free_device 
	calls
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Dmitry,

2010/7/2 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Axel,
>
> On Fri, Jul 02, 2010 at 09:42:57AM +0800, Axel Lin wrote:
>> input_free_device should only be used if input_register_device()
>> was not called yet or if it failed.
>> This patch removes unnecessary input_free_device calls.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/platform/x86/fujitsu-laptop.c |   21 ++++++++-------------
>>  1 files changed, 8 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
>> index e325aeb..dab1a0e 100644
>> --- a/drivers/platform/x86/fujitsu-laptop.c
>> +++ b/drivers/platform/x86/fujitsu-laptop.c
>> @@ -686,8 +686,10 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>>       set_bit(KEY_UNKNOWN, input->keybit);
>>
>>       error = input_register_device(input);
>> -     if (error)
>> -             goto err_free_input_dev;
>> +     if (error) {
>> +             input_free_device(input);
>> +             goto err_stop;
>> +     }
>
> Instead of using mixed in-line and goto style cleanup I prefer doig the
> following:
>
>  err_unregister_input_dev:
>        input_unregister_device(input);
>        input = NULL; <-- !!!
>  err_free_input_dev:
>        input_free_device(input);
>
> input_free_device() happily accepts NULL pointers.

Thanks for the review. I will send a revised patch.

Regards,
Axel
>
> Otherwise the patch looks good.
>
> Thanks.
>
> --
> Dmitry
>
