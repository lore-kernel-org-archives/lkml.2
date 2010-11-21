Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0KUKDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 05:03:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51181 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab0KUKDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 05:03:32 -0500
Date: Sun, 21 Nov 2010 11:03:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nigel Cunningham <lkml@nigelcunningham.com.au>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during
 suspend/resume
Message-ID: <20101121100328.GA2939@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nigel Cunningham <lkml@nigelcunningham.com.au>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
 <4CE8E60D.9000303@nigelcunningham.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE8E60D.9000303@nigelcunningham.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Nov 21, 2010 at 08:27:41PM +1100, Nigel Cunningham wrote:
> Hi.
> 
> We have a few others things that want to modify their behaviour
> according to whether we're doing the atomic copy/restore. Perhaps it
> would be an idea to just use a single flag, perhaps a value for
> system_state?

I agree, it would be nicer if we don't introduce a special flag
just for that. Other than that, I like all sane code that speeds up
suspend/resume :). I've attached before/after dmesg excerpts on my
system with the patch ontop of v2.6.37-rc2-181-gb86db47. We end up
saving 11601 µsecs according to CONFIG_PRINTK_TIME but hey, the code is
simple enough :).

Tested-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="suspend.before"

[  122.004099] [drm] Resetting GPU
[  122.014614] PM: Syncing filesystems ... done.
[  122.027334] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  122.039644] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  122.050629] PM: Preallocating image memory... done (allocated 147655 pages)
[  122.324258] PM: Allocated 590620 kbytes in 0.27 seconds (2187.48 MB/s)
[  122.324298] Suspending console(s) (use no_console_suspend to debug)
[  122.325991] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[  122.326104] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  122.330976] serial 00:0b: disabled
[  122.331077] serial 00:0b: wake-up capability disabled by ACPI
[  122.331161] i8042 kbd 00:0a: wake-up capability enabled by ACPI
[  122.331560] pci 0000:01:00.0: PCI INT A disabled
[  122.331967] ATIIXP_IDE 0000:00:14.1: PCI INT A disabled
[  122.332736] ahci 0000:00:11.0: PCI INT A disabled
[  122.432770] HDA Intel 0000:01:00.1: PCI INT B disabled
[  122.432932] ACPI handle has no context!
[  122.433187] HDA Intel 0000:00:14.2: PCI INT A disabled
[  122.444799] PM: freeze of devices complete after 119.816 msecs
[  122.448594] PM: late freeze of devices complete after 3.785 msecs
[  122.448628] Disabling non-boot CPUs ...
[  122.471872] CPU 1 is now offline
[  122.489261] CPU 2 is now offline
[  122.498177] CPU 3 is now offline
[  122.498183] lockdep: fixing up alternatives.
[  122.498228] SMP alternatives: switching to UP code
[  122.509784] Extended CMOS year: 2000
[  122.510008] PM: Creating hibernation image:
[  122.510008] PM: Need to copy 146817 pages

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="suspend.after"

[   72.337143] [drm] Resetting GPU
[   72.347054] PM: Syncing filesystems ... done.
[   72.377683] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   72.390714] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   72.401705] PM: Preallocating image memory... done (allocated 147611 pages)
[   72.690885] PM: Allocated 590444 kbytes in 0.28 seconds (2108.72 MB/s)
[   72.690925] Suspending console(s) (use no_console_suspend to debug)
[   72.692422] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[   72.692432] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[   72.704185] serial 00:0b: disabled
[   72.704275] serial 00:0b: wake-up capability disabled by ACPI
[   72.704356] i8042 kbd 00:0a: wake-up capability enabled by ACPI
[   72.704742] pci 0000:01:00.0: PCI INT A disabled
[   72.705258] ATIIXP_IDE 0000:00:14.1: PCI INT A disabled
[   72.705915] ahci 0000:00:11.0: PCI INT A disabled
[   72.806818] HDA Intel 0000:01:00.1: PCI INT B disabled
[   72.806831] HDA Intel 0000:00:14.2: PCI INT A disabled
[   72.807141] ACPI handle has no context!
[   72.819836] PM: freeze of devices complete after 128.198 msecs
[   72.823408] PM: late freeze of devices complete after 3.565 msecs
[   72.823443] Disabling non-boot CPUs ...
[   72.840884] CPU 1 is now offline
[   72.866229] CPU 2 is now offline
[   72.884239] CPU 3 is now offline
[   72.886941] Extended CMOS year: 2000
[   72.887016] PM: Creating hibernation image:
[   72.887016] PM: Need to copy 146787 pages


--2oS5YaxWCcQjTEyO--
