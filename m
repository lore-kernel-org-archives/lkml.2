Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0KFOve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:51:34 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64125 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0KFOvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:51:33 -0400
To: kay.sievers@vrfy.org
Cc: gregkh@suse.de, cbouatmailru@gmail.com, ak@linux.intel.com,
        axboe@kernel.dk, shemminger@vyatta.com, ebiederm@xmission.com,
        stern@rowland.harvard.edu, James.Bottomley@suse.de,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        randy.dunlap@oracle.com, tj@kernel.org, davem@davemloft.net,
        perex@perex.cz, tiwai@suse.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1] udevd-event prints errors.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201011060307.GIG13040.OFFJOVHMSFLOtQ@I-love.SAKURA.ne.jp>
	<20101105200245.GA1645@suse.de>
	<201011062018.ADJ30249.OVOOJFMFHQFStL@I-love.SAKURA.ne.jp>
	<AANLkTi=BL4N7T1VDU2Pxd3pmm-=TwzRN_JqWeMFahEY=@mail.gmail.com>
In-Reply-To: <AANLkTi=BL4N7T1VDU2Pxd3pmm-=TwzRN_JqWeMFahEY=@mail.gmail.com>
Message-Id: <201011062351.GAC13589.FHStJFLOQMVFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 6 Nov 2010 23:51:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kay Sievers wrote:
> >> Other than that, everything works ok, right?
> > Right.
> 
> It's something that should be fixed in the udev rules. This is the
> fixed line, we used in later releases. It adds an additional match to
> prevent the warning you see:
>   SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*", WAIT_FOR_SYSFS="ioerr_cnt"
> 
> All of that is not needed with current kernels, it was a hacky
> workaround for broken sysfs/event timing issues we had years ago.

I see.
Applying below patch solved these error messages on my CentOS 5.5 environment.

Thank you.

--- /etc/udev/rules.d/05-udev-early.rules
+++ /etc/udev/rules.d/05-udev-early.rules
@@ -1,7 +1,7 @@
 # sysfs is populated after the event is sent
 ACTION=="add", DEVPATH=="/devices/*", ENV{PHYSDEVBUS}=="?*", WAIT_FOR_SYSFS="bus"
 ACTION=="add", SUBSYSTEM=="net", WAIT_FOR_SYSFS="address"
-ACTION=="add", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"                    
+ACTION=="add", SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*", WAIT_FOR_SYSFS="ioerr_cnt"
 
 # ignore these events until someone needs them
 SUBSYSTEM=="drivers",		OPTIONS="ignore_device"
