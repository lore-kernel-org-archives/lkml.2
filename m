Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0GIKCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:02:13 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51052 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0GIKCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:02:12 -0400
Date: Fri, 9 Jul 2010 13:02:10 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI
 *
In-Reply-To: <20100709072619.GE10743@elte.hu>
Message-ID: <alpine.SOC.1.00.1007091253050.5156@math.ut.ee>
References: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee> <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com> <alpine.SOC.1.00.1007090121300.27187@math.ut.ee> <20100709072619.GE10743@elte.hu>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Meelis do you have a boot trace from 2.6.34?  Meelis can you confirm
> > > that you don't come up in XT_PIC mode in 2.6.34?
> > 
> > Now that was a good question. It's XT-PIC in 2.6.34 too, just the ERROR: 
> > lines are not there.
> 
> So it's not really a regression, just a bit noisier bootup?

Yes, seems so - sorry for the overreaction over the ERROR's.
Both old and new kernels have XT-PIC-XT in /proc/interrupts and both 
work.

Notable differneces from dmesg. The TSC calibration one is interesting. 
2.6.34 tells a failure for some reason. Re-testing 2.6.34 results in 
normal "Fast TSC calibration using PIT"...

-nr_irqs_gsi: 16
+nr_irqs_gsi: 17


-Fast TSC calibration failed
-TSC: PIT calibration matches PMTIMER. 1 loops
-Detected 897.087 MHz processor.
-Calibrating delay loop (skipped), value calculated using timer frequency.. 1794.17 BogoMIPS (lpj=3588348)
+Fast TSC calibration using PIT
+Detected 896.953 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer frequency.. 1793.90 BogoMIPS (lpj=3587812)


+ERROR: Unable to locate IOAPIC for GSI 8
+ERROR: Unable to locate IOAPIC for GSI 13
+ERROR: Unable to locate IOAPIC for GSI 12
+ERROR: Unable to locate IOAPIC for GSI 1
+ERROR: Unable to locate IOAPIC for GSI 6
+ERROR: Unable to locate IOAPIC for GSI 4
+ERROR: Unable to locate IOAPIC for GSI 3
+ERROR: Unable to locate IOAPIC for GSI 7


-- 
Meelis Roos (mroos@linux.ee)
