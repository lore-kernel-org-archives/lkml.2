Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0E1Aqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:46:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49577 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab0E1Aqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:46:50 -0400
Subject: Re: Clock jumps
From: john stultz <johnstul@us.ibm.com>
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BFF0F3F.9050800@birkenwald.de>
References: <loom.20100524T171038-56@post.gmane.org>
	 <20100525062100.GP22163@redhat.com>	<4BFD5616.6070302@cora.nwra.com>
	 <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
	 <htmdsk$9kn$1@dough.gmane.org>
	 <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>
	 <4BFEE8A2.30706@birkenwald.de> <1275004816.1813.15.camel@work-vm>
	 <4BFF0F3F.9050800@birkenwald.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 17:46:45 -0700
Message-ID: <1275007605.1813.18.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 02:33 +0200, Bernhard Schmidt wrote:
> On 28.05.2010 02:00, john stultz wrote:
> > Looking at the diff:
> > --- dmesg-lenny 2010-05-27 16:45:33.000000000 -0700
> > +++ dmesg-squeeze       2010-05-27 16:46:14.000000000 -0700
> > @@ -132,8 +132,8 @@
> >   console [ttyS1] enabled
> >   hpet clockevent registered
> >   Fast TSC calibration using PIT
> > -Detected 2660.398 MHz processor.
> > -Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.79 BogoMIPS (lpj=10641592)
> > +Detected 2613.324 MHz processor.
> > +Calibrating delay loop (skipped), value calculated using timer frequency.. 5226.64 BogoMIPS (lpj=10453296)
> >   Security Framework initialized
> >   Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> >   Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> > @@ -160,7 +160,7 @@
> >   CPU0: Intel(R) Xeon(R) CPU            3075  @ 2.66GHz stepping 0b
> >   Booting Node   0, Processors  #1
> >   Brought up 2 CPUs
> > -Total of 2 processors activated (10640.79 BogoMIPS).
> > +Total of 2 processors activated (10546.63 BogoMIPS).
> >   NET: Registered protocol family 16
> >   ACPI: bus type pci registered
> >   PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> >
> > So you can see in the above the during the second boot the TSC
> > calibration was badly mis-calculated. This was the cause of the skew.
> >
> > Not sure how that might be linked to the distro upgrade. It could have
> > been something like SMI damage during the calibration time, but I
> > thought the calibration loop watched for that.
> >
> > Bernhard: I expect with all those vms, this machine isn't rebooted
> > frequently. So could you look at the logs to see how much the  "Detected
> > xxxx.yyy MHz processor." line varies by across a few other boots (if
> > they still exist?).
> 
> Correct, the box isn't rebooted often, but I do have a few dmesg outputs 
> laying around. lpj was always almost the same until the very last boot 
> which screwed up the clock.
> 
> dmesg:[    0.000000] Linux version 2.6.33 (root@svr02) (gcc version 
> 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sun Mar 7 23:01:45 CET 2010
> dmesg:[    0.008005] Calibrating delay loop (skipped), value calculated 
> using timer frequency.. 5226.64 BogoMIPS (lpj=10453296)
> dmesg:[    0.288002] Total of 2 processors activated (10546.63 BogoMIPS).

Yea. The bogomips/loops per jiffies are actually calculated with a
different chunk of code (although its interesting it miscalculated in
both cases).

Could you send the "Detected xxxx.yyy MHz processor." lines as well?

thanks
-john


