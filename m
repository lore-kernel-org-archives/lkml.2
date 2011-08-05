Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1HEUMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:12:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1HEUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:12:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
Date: Fri, 5 Aug 2011 22:13:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1108051557500.2055-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108051557500.2055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108052213.40969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 05, 2011, Alan Stern wrote:
> On Fri, 5 Aug 2011, Rafael J. Wysocki wrote:
> 
> > On Friday, August 05, 2011, Jesper Juhl wrote:
> > > Hi
> > > 
> > > I just experienced a kernel crash when trying to suspend my Lenovo 
> > > Thinkpad T510 (model 4384-GJG) laptop.
> > > 
> > > Normally I just shut the lid and the little moon icon lights up telling me 
> > > that the laptop has suspended. This time was different; the moon icon 
> > > didn't light up as it usually does, so I opened the lid again and found a 
> > > kernel crash dump on the screen. The machine was completely dead at this 
> > > point, so all I could do was take a photo of the screen - nothing had made 
> > > it to the log files either (checked after a reboot).
> > > 
> > > The image I took of the screen with the crash info is available here:
> > >  http://personal.chaosbits.net/suspend-crash.jpg
> > > 
> > > The kernel version is 2.6.39.3
> > > The kernel config is attached as '2.6.39.3-config.gz'
> > > The distribution is Arch Linux 64bit.
> > > 
> > > Here is a partial transcript of the image (typed in manually, so check the 
> > > image if you suspect an error - I also left out function addresses/offsets 
> > > and other details before/after the backtrace to save me some typing, so 
> > > check the image for the full details) :
> > > 
> > > Call Trace:
> > >   ? wq_worker_sleeping
> > >   schedule
> > >   ? cfq_put_queue
> > >   ? cic_free_func
> > >   ? kmem_cache_free
> > >   ? put_io_context
> > >   do_exit
> > >   oops_end
> > >   die
> > >   do_trap
> > >   do_invalid_op
> > >   ? free_msi_irqs
> > >   ? find_busiest_group
> > >   ? pci_conf1_write
> > >   pci_disable_msi
> > >   e1000e_reset_interrupt_capabillity
> > >   __e1000_runtime_suspend
> > >   ? __switch_to
> > >   pci_pm_runtime_suspend
> > >   ? pci_legacy_suspend_late
> > >   rpm_callback
> > >   ? schedule
> > >   rpm_suspend
> > >   ? linkwatch_do_dev
> > >   ? pm_schedule_suspend
> > >   pm_runtime_work
> > >   process_one_work
> > >   worker_thread
> > >   ? manage_workers.isra.29
> > >   kthread
> > >   kernel_thread_helper
> > >   ? kthread_worker
> > >   ? gs_change
> > > 
> > > I've not experienced this before with this kernel, nor with earlier or 
> > > newer ones, so it's not exactely reproducible on demand, so it's anyones 
> > > guess when this was introduced (or if it's been there for ages, just 
> > > triggers rarely)...
> > > 
> > > One detail that may be relevant; normally when I suspend the laptop I do 
> > > so before unplugging any cables or suspend after not having anything 
> > > plugged in for ages (or at all). This time I was in a hurry, so I quickly 
> > > unplugged the power, 3 usb cables and the ethernet cable and then quickly 
> > > slammed the lid shut. Not sure if that has an impact on triggering this 
> > > though. I tried reproducing that scenario 4-5 times, but the laptop 
> > > suspended fine when I did that.
> > > 
> > > If you require further information then please let me know and I'll be 
> > > happy to provide it. 
> > > 
> > > I'll of course try to submit more details if it happens again, but if 
> > > someone has a good guess as to how to provoke it or an idea for a fix I'd 
> > > sure like to know.
> > 
> > I don't know how to fix it yet, but I think I know what the problem is.
> > Namely, a runtime suspend of the Ethernet adapter as occured in parallel with
> > the system-wide suspend and they clashed.  The runtime suspend has probably
> > been provoked by detaching the Ethernet cable from the box.
> 
> For them to clash in that way would mean that the PM workqueue didn't
> get frozen.

Not necessarily, I think.  It's sufficient that system suspend is started
while the runtime PM operation is in progress.

> Is that possible?

Shouldn't be.

Thanks,
Rafael
