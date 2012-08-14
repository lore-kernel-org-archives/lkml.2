Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2HNHVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 03:21:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52574 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2HNHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 03:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <tip-bcd951cf10f24e341defcd002c15a1f4eea13ddb@git.kernel.org>
References: <20120716103948.563736676@linutronix.de>
	<tip-bcd951cf10f24e341defcd002c15a1f4eea13ddb@git.kernel.org>
Date: Tue, 14 Aug 2012 12:50:58 +0530
X-Google-Sender-Auth: UWdw93a_kr6mLyNmpj8HhRswkDc
Message-ID: <CAOh2x=ny-76y0S=Nukz-Gz7OUZT19evXSVUWmFG2KdLoHcN6wQ@mail.gmail.com>
Subject: Re: [tip:smp/hotplug] watchdog: Use hotplug thread infrastructure
From: viresh kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        namhyung@kernel.org, paulmck@linux.vnet.ibm.com,
        Amit Kucheria <amit.kucheria@linaro.org>, steve.bannister@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 8:43 PM, tip-bot for Thomas Gleixner
<tglx@linutronix.de> wrote:
> Commit-ID:  bcd951cf10f24e341defcd002c15a1f4eea13ddb
> Gitweb:     http://git.kernel.org/tip/bcd951cf10f24e341defcd002c15a1f4eea13ddb
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon, 16 Jul 2012 10:42:38 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 13 Aug 2012 17:01:07 +0200
>
> watchdog: Use hotplug thread infrastructure

Hi Thomas,

I am maintaining http://git.linaro.org/gitweb?p=arm/big.LITTLE/mp.git;a=summary
linaro tree for big.LITTLE MP work. I had a branch
per-cpu-thread-hotplug-v3-fixed
with your stuff in it + Paul's fix.

I was rebasing it over 3.6-rc1 and got conflicts, actually a routine is added in
kernel/watchdog.c file, which uses functions removed in your patch:


commit 45226e944ce071d0231949f2fea90969437cd2dc
Author: Sameer Nanda <snanda@chromium.org>
Date:   Mon Jul 30 14:40:00 2012 -0700

    NMI watchdog: fix for lockup detector breakage on resume


+#ifdef CONFIG_SUSPEND
+/*
+ * On exit from suspend we force an offline->online transition on the boot CPU
+ * so that the PMU state that was lost while in suspended state gets set up
+ * properly for the boot CPU.  This information is required for restarting the
+ * NMI watchdog.
+ */
+void lockup_detector_bootcpu_resume(void)
+{
+       void *cpu = (void *)(long)smp_processor_id();
+
+       cpu_callback(&cpu_nfb, CPU_DEAD_FROZEN, cpu);
+       cpu_callback(&cpu_nfb, CPU_UP_PREPARE_FROZEN, cpu);
+       cpu_callback(&cpu_nfb, CPU_ONLINE_FROZEN, cpu);
+}
+#endif
+


Now, cpu_callback is removed in your patch. Can you please share an updated
patch to fix this issue? Or let me know how to handle it?

viresh
