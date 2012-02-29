Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2B2SDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:03:51 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52348 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab2B2SDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:03:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Keith Chew <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
Date: Wed, 29 Feb 2012 10:07:00 -0800
In-Reply-To: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	(Keith Chew's message of "Sat, 18 Feb 2012 11:54:25 +1300")
Message-ID: <m1ehtd8qez.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18M6XjhTaj71x2uTI5EPNPeZvuTjsxTbEQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4933]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Keith Chew <keith.chew@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Chew <keith.chew@gmail.com> writes:

> Hi
>
> To test the reliability of a hardware, I have a script which reboots a
> machine every 15 minutes after boot up. This machine has a dual video
> output, VGA and DVI-D, both driven via an intel GM45 chipset (I am
> using kernel 2.6.39.24 kernel intel drivers).
>
> Some interesting results (which can be reproduced consistently):
> "echo b > /proc/sysrq-trigger" via DVI-D - after 2-3 days, it hangs
> (freezes) before reboot (dmesg only shows "Resetting...", nothing

My blind guess would be that it is the BIOS on the machine that is hung.

> after that, no panic, stack trace, etc)
> "echo b > /proc/sysrq-trigger" via VGA - runs > 1 week
> "reboot -fn" via VGA or DVI-D - runs > 1 week
> "reboot" via VGA or DVI-D - runs > 1 week
>
> I suspect that the intel graphics driver is not happy with the "echo b
>> /proc/sysrq-trigger" when it is still running.
>
> I would like to make the "echo b" successfully reboot the machine, but
> this would appear to be a hardware bug? Is there anything that can be
> done in the kernel to make the "echo b" successfully work 100%?

echo b > /proc/sysrq-trigger triggers the emergency_restart path which
tries but skips some steps so that it has a reasonable chance of working
when the kernel is wedged, it looks like some of those steps it skips
are needed on your hardware.

Eric
