Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2B2UtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:49:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45306 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2B2UtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:49:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Keith Chew <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
Date: Wed, 29 Feb 2012 12:49:03 -0800
In-Reply-To: <CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	(Keith Chew's message of "Thu, 1 Mar 2012 07:28:07 +1300")
Message-ID: <87obshxt4w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18t/x/pc+rN6NIMcy91OPUw9KTi5ffTN5Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4869]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Keith Chew <keith.chew@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Chew <keith.chew@gmail.com> writes:

> Hi Eric
>
> <snip>
>
>>> Some interesting results (which can be reproduced consistently):
>>> "echo b > /proc/sysrq-trigger" via DVI-D - after 2-3 days, it hangs
>>> (freezes) before reboot (dmesg only shows "Resetting...", nothing
>>
>> My blind guess would be that it is the BIOS on the machine that is hung.
>>
>
> We have contacted the manufacturer, and they do not believe this is
> the case as the BIOS does not really do much during the reboot.
> Unfortunately, we do not have enough knowledge on the inner workings
> of the BIOS to help or diagnose further. Any pointers here will be
> helpful.

Historically a lot of issues have had to do with which cpu you are
entering the bios from.  So you might try pinning your process
to differen cpus and see if you can make the failure more deterministic.

>>> I would like to make the "echo b" successfully reboot the machine, but
>>> this would appear to be a hardware bug? Is there anything that can be
>>> done in the kernel to make the "echo b" successfully work 100%?
>>
>> echo b > /proc/sysrq-trigger triggers the emergency_restart path which
>> tries but skips some steps so that it has a reasonable chance of working
>> when the kernel is wedged, it looks like some of those steps it skips
>> are needed on your hardware.
>>
>
> Yes, I have looked into the kernel code and it does not do much,
> except to tell the hardware to reboot (either via BIOS, keyboard,
> ACPI, etc). I have also tried the reboot=b, reboot=k and reboot=a
> options, and all of them can cause a hang, with reboot=b lasting the
> longest.
>
> We have extended our testing time, and have some more worrying
> results. The command "reboot -fn" which runs > 1 week, got a hang
> after 2 weeks of running. We are now testing with just "reboot" to see
> how long that last.

Ugh.  The other possibility is that there is an intermittent failure in
the hardware, that prevents the boot/reboot.  Wrong values on pull-up
resistors have been known to cause that kind of thing.

Eric
