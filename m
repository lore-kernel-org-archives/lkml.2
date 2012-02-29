Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030281Ab2B2S2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:28:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45834 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965743Ab2B2S2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:28:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keith.chew@gmail.com designates 10.101.175.2 as permitted sender) smtp.mail=keith.chew@gmail.com; dkim=pass header.i=keith.chew@gmail.com
MIME-Version: 1.0
In-Reply-To: <m1ehtd8qez.fsf@fess.ebiederm.org>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
Date: Thu, 1 Mar 2012 07:28:07 +1300
Message-ID: <CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
From: Keith Chew <keith.chew@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric

<snip>

>> Some interesting results (which can be reproduced consistently):
>> "echo b > /proc/sysrq-trigger" via DVI-D - after 2-3 days, it hangs
>> (freezes) before reboot (dmesg only shows "Resetting...", nothing
>
> My blind guess would be that it is the BIOS on the machine that is hung.
>

We have contacted the manufacturer, and they do not believe this is
the case as the BIOS does not really do much during the reboot.
Unfortunately, we do not have enough knowledge on the inner workings
of the BIOS to help or diagnose further. Any pointers here will be
helpful.

<snip>
>>
>> I would like to make the "echo b" successfully reboot the machine, but
>> this would appear to be a hardware bug? Is there anything that can be
>> done in the kernel to make the "echo b" successfully work 100%?
>
> echo b > /proc/sysrq-trigger triggers the emergency_restart path which
> tries but skips some steps so that it has a reasonable chance of working
> when the kernel is wedged, it looks like some of those steps it skips
> are needed on your hardware.
>

Yes, I have looked into the kernel code and it does not do much,
except to tell the hardware to reboot (either via BIOS, keyboard,
ACPI, etc). I have also tried the reboot=b, reboot=k and reboot=a
options, and all of them can cause a hang, with reboot=b lasting the
longest.

We have extended our testing time, and have some more worrying
results. The command "reboot -fn" which runs > 1 week, got a hang
after 2 weeks of running. We are now testing with just "reboot" to see
how long that last.

Regards
Keith
