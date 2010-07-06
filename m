Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0GFIIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:08:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55819 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0GFIIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=n3jnyTMJql1NHr6Oo8oP90ejJ1tHKjtpLfdfba+YS9cPgcKA2DHhlwHhyyRRTfPr4l
         iTSOaWBeWZ2iho7RYohlqaX4hgMCKcDPGXmIc6yyvWb85ubVElIThIIPtdI5cnc6Lb4E
         eOS1fhlEkD01P5jZ88C1gDE15odXMrf3MHmig=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <201007060956.45726.trenn@suse.de>
References: <1278383426.12801.15.camel@mola> <201007060956.45726.trenn@suse.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 6 Jul 2010 16:07:49 +0800
Message-ID: <AANLkTimpkmAoPep9s1Hp5gZvdjzDm_1iBO32xYeAQL5F@mail.gmail.com>
Subject: Re: [PATCH] hp-wmi: add return value checking for 
	input_allocate_device()
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Anisse Astier <anisse@astier.eu>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Thomas,
2010/7/6 Thomas Renninger <trenn@suse.de>:
> Hi,
>
> it's incredible how much cleanups and fixes you find in this
> handful of drivers... It's very much appreciated!
>
> On Tuesday 06 July 2010 04:30:26 Axel Lin wrote:
>> Add error checking and return -ENOMEM if input_allocate_device() fail.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/platform/x86/hp-wmi.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
>> index 51c07a0..c508e20 100644
>> --- a/drivers/platform/x86/hp-wmi.c
>> +++ b/drivers/platform/x86/hp-wmi.c
>> @@ -402,6 +402,8 @@ static int __init hp_wmi_input_setup(void)
>>       int err;
>>
>>       hp_wmi_input_dev = input_allocate_device();
>> +     if (!hp_wmi_input_dev)
>> +             return -ENOMEM;
>>
>>       hp_wmi_input_dev->name = "HP WMI hotkeys";
>>       hp_wmi_input_dev->phys = "wmi/input0";
> But also hp_wmi_input_setup() call should get checked and if it
> fails, the previous wmi_install_notify_handler() must get uninstalled
> again. Hm, probably the whole driver shouldn't load then and
> the error code from hp_wmi_input_setup() can be returned in
> hp_wmi_init(void).
>
> Do you mind to incorporate above if you agree.

Checking hp_wmi_input_setup() is already done in my previous patch.
( which is already merged in platform-driver-x86 tree.
http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=commitdiff;h=b035d5f9fcb6cd6bba44b764b17d885f4d960d37
).
Thus this patch only adds the return value checking for
input_allocate_device() in hp_wmi_input_setup().

Regards,
Axel


>
> Thanks,
>
>   Thomas
>
