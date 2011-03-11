Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1CKAWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:22:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36085 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1CKAWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:references:message-id:user-agent
         :mime-version:content-type;
        b=pAItUvvQeYfHagh/Y6FfFrvDbtba69JbpuJfAwTDKU2l3R/+mYQ2uZl5qcNIjbRdSp
         f+/T1//aap2DR5kJe5/xhbY4uq7LlxG0Cz4gfDw6gRnJK/Nin1mDhyid7zQJukVR5s4Q
         +TzPfH5Kb8wyIzn5aRGi6PEnPPqPYUGHJ9zEo=
From: Wang Lei <f3d27b@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Date: Fri, 11 Mar 2011 08:04:51 +0800
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
	<201103092125.43950.rjw@sisk.pl>
	<4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
	<201103100106.36678.rjw@sisk.pl>
Message-ID: <4d796b47.20f98e0a.2695.fffff615@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday, March 10, 2011, Wang Lei wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > On Wednesday, March 09, 2011, Wang Lei wrote:
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >> 
>> >> >
>> >> > There was only one commit in that area since 2.6.38-rc6, but it shouldn't
>> >> > affect the functionality this way.
>> >> >
>> >> > Is yout thermal management controlled by ACPI?
>> >> >
>> >> > Rafael
>> >> 
>> >> Thanks for your reply!
>> >> 
>> >> How could I know that?
>> >
>> > What does "ls -l /sys/class/thermal/cooling_device0/device" say?
>> >
>> > Rafael
>> 
>> [~]$ ls -l /sys/class/thermal/cooling_device0/device
>> lrwxrwxrwx 1 root root 0 Mar 10 07:13 /sys/class/thermal/cooling_device0/device -> ../../../LNXSYSTM:00/device:47/PNP0C0B:00
>> [~]$
>
> That's ACPI.
>
> I don't know, however, which change might cause the problem to happen.
>
> Can you bisect the commits between 2.6.38-rc6 and -rc7 to find the one that
> introduced the issue?
>
> Rafael

Thanks, Rafael.
Bisect stopped at commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12

--------------------
[~/repository/kernel]$ git bisect good
7f74f8f28a2bd9db9404f7d364e2097a0c42cc12 is the first bad commit
commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
Author: Andreas Herrmann <andreas.herrmann3@amd.com>
Date:   Thu Feb 24 15:53:46 2011 +0100

    x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
    
    On some SB800 systems polarity for IOAPIC pin2 is wrongly
    specified as low active by BIOS. This caused system hangs after
    resume from S3 when HPET was used in one-shot mode on such
    systems because a timer interrupt was missed (HPET signal is
    high active).
    
    For more details see:
    
      http://marc.info/?l=linux-kernel&m=129623757413868
    
    Tested-by: Manoj Iyer <manoj.iyer@canonical.com>
    Tested-by: Andre Przywara <andre.przywara@amd.com>
    Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Cc: Borislav Petkov <borislav.petkov@amd.com>
    Cc: stable@kernel.org # 37.x, 32.x
    LKML-Reference: <20110224145346.GD3658@alberich.amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 918adb3e08ef8cd258016dc46afab842e1be65fc 77d76d6f2451b16f963ce1ffe183aacfed9d994d M	arch
[~/repository/kernel]$ 
--------------------

So, I Cc to Andreas Herrmann, hope you will notice and help fix this.

Thanks, all you hackers!

-- 
Regards,
Lei
