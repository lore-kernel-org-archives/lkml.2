Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0KBNO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:14:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44799 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab0KBNOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:14:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: 2.6.37 rc1 doesn't suspend to ram
Date: Tue, 2 Nov 2010 14:13:50 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: suspend-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <201011011955.39485.a.miskiewicz@gmail.com> <201011011959.08933.a.miskiewicz@gmail.com>
In-Reply-To: <201011011959.08933.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011021413.50822.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 01, 2010, Arkadiusz Miskiewicz wrote:
> On Monday 01 of November 2010, Arkadiusz Miskiewicz wrote:
> > Hi,
> > 
> > Some linus tree git commit in last few weeks broke suspend to ram here,
> > s2ram -a3 -f says:
> > 
> > 4310  open("/sys/power/state", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 16
> > 4310  fstat(16, {st_mode=S_IFREG|0644, st_size=4096, ...}) = 0
> > 4310  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> > 0) = 0x7f81c05bc000 4310  write(16, "mem", 3)               = -1 EIO
> > (Input/output error) 4310  close(16)                         = 0
> > 4310  munmap(0x7f81c05bc000, 4096)      = 0
> > 4310  dup(2)                            = 16
> > 4310  fcntl(16, F_GETFL)                = 0x8002 (flags O_RDWR|O_LARGEFILE)
> > 4310  fstat(16, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 1), ...}) = 0
> > 4310  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> > 0) = 0x7f81c05bc000 4310  lseek(16, 0, SEEK_CUR)            = -1 ESPIPE
> > (Illegal seek) 4310  write(16, "s2ram_do: Input/output error\n", 29) = 29
> > 4310  close(16)                         = 0
> 
> [ 2012.149491] PM: Syncing filesystems ... done.
> [ 2013.092294] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 2013.108138] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 2013.124226] Suspending console(s) (use no_console_suspend to debug)
> [ 2013.144256] btusb_intr_complete: hci0 urb ffff8800b446dcc0 failed to resubmit (1)
> [ 2013.145254] btusb_bulk_complete: hci0 urb ffff8800b446d180 failed to resubmit (1)
> [ 2013.146255] btusb_bulk_complete: hci0 urb ffff8800b446d3c0 failed to resubmit (1)
> [ 2013.297335] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 2013.297715] sd 0:0:0:0: [sda] Stopping disk
> [ 2013.364129] tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
> [ 2013.364145] legacy_suspend(): pnp_bus_suspend+0x0/0x80 returns -5
> [ 2013.364151] PM: Device 00:0a failed to suspend: error -5
> [ 2014.245071] PM: Some devices failed to suspend
> [ 2014.245160] sd 0:0:0:0: [sda] Starting disk
> [ 2014.932062] PM: resume of devices complete after 686.981 msecs
> [ 2014.932878] Restarting tasks ... done.
> [ 2014.941645] video LNXVIDEO:00: Restoring backlight state

Can you try the patch at http://lkml.org/lkml/2010/10/21/456, please?

Rafael
