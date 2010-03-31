Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0CaXdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:33:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804Ab0CaXdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:33:49 -0400
Date: Wed, 31 Mar 2010 16:32:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Message-Id: <20100331163234.8e875ae8.akpm@linux-foundation.org>
In-Reply-To: <1269775909.5301.4.camel@localhost.localdomain>
References: <1269775909.5301.4.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Mar 2010 13:31:49 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> This warning/error/notice is new in 2.6.34-rc2+:

Let's add some cc's.  It might be a DRM bug.

I'll ask Rafael and Maciej to track this as a post-2.6.33 regression,
thanks.

> [ 1878.810147] PM: Syncing filesystems ... done.
> [ 1878.903316] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 1878.916589] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 1878.929866] Suspending console(s) (use no_console_suspend to debug)
> [ 1878.930229] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 1878.930370] sd 0:0:0:0: [sda] Stopping disk
> [ 1878.981086] atl1c 0000:01:00.0: PCI INT A disabled
> [ 1878.981369] uhci_hcd 0000:00:1d.2: PCI INT D disabled
> [ 1878.981379] uhci_hcd 0000:00:1d.1: PCI INT B disabled
> [ 1878.981389] uhci_hcd 0000:00:1d.0: PCI INT A disabled
> [ 1878.981454] HDA Intel 0000:00:1b.0: PCI INT A disabled
> [ 1878.981500] ACPI handle has no context!
> [ 1878.981529] ehci_hcd 0000:00:1a.7: PCI INT D disabled
> [ 1878.981540] uhci_hcd 0000:00:1a.0: PCI INT A disabled
> [ 1878.981602] IMA: unmeasured files on fsmagic: 1021994
> [ 1878.981605] ima_dec_counts: open/free imbalance (r:0 w:-1 o:-1)
> [ 1878.981609] Pid: 4888, comm: async/10 Tainted: G        W  2.6.34-rc2 #88
> [ 1878.981612] Call Trace:
> [ 1878.981620]  [<c0886ac2>] ? printk+0x1d/0x23
> [ 1878.981627]  [<c05f966f>] ima_file_free+0x16f/0x210
> [ 1878.981632]  [<c04d7132>] __fput+0xf2/0x1f0
> [ 1878.981636]  [<c04d724d>] fput+0x1d/0x30
> [ 1878.981641]  [<c06cbd2f>] drm_gem_object_free_common+0x1f/0x40
> [ 1878.981645]  [<c06cbdd0>] ? drm_gem_object_free+0x0/0x40
> [ 1878.981649]  [<c06cbe01>] drm_gem_object_free+0x31/0x40
> [ 1878.981653]  [<c061d20c>] kref_put+0x2c/0x60
> [ 1878.981658]  [<c06e8078>] i915_gem_cleanup_ringbuffer+0x48/0x70
> [ 1878.981662]  [<c06e97ec>] i915_gem_idle+0x9c/0x120
> [ 1878.981666]  [<c06dcefd>] i915_drm_freeze+0x3d/0xa0
> [ 1878.981670]  [<c06dd01e>] i915_pm_suspend+0x2e/0x80
> [ 1878.981674]  [<c08871ca>] ? wait_for_common+0x1a/0x100
> [ 1878.981679]  [<c0636269>] pci_pm_suspend+0x49/0x110
> [ 1878.981682]  [<c0636220>] ? pci_pm_suspend+0x0/0x110
> [ 1878.981687]  [<c07194f1>] pm_op+0x181/0x1d0
> [ 1878.981691]  [<c07126f4>] ? device_for_each_child+0x54/0x60
> [ 1878.981695]  [<c0719eaf>] __device_suspend+0xbf/0x110
> [ 1878.981699]  [<c071a2f3>] async_suspend+0x23/0x60
> [ 1878.981703]  [<c044ff25>] async_thread+0xc5/0x210
> [ 1878.981707]  [<c0886e31>] ? schedule+0x1e1/0x450
> [ 1878.981713]  [<c042c030>] ? default_wake_function+0x0/0x20
> [ 1878.981716]  [<c044fe60>] ? async_thread+0x0/0x210
> [ 1878.981720]  [<c0449254>] kthread+0x74/0x80
> [ 1878.981724]  [<c04491e0>] ? kthread+0x0/0x80
> [ 1878.981728]  [<c04034be>] kernel_thread_helper+0x6/0x10
> [ 1878.986489] iint_free: writecount: -1
> [ 1878.986492] iint_free: opencount: -1
> [ 1878.986494] iint_free: writecount: -1
> [ 1878.986496] iint_free: opencount: -1
> [ 1878.993205] ehci_hcd 0000:00:1d.7: PCI INT A disabled
> [ 1879.649836] PM: suspend of devices complete after 719.812 msecs
> [ 1879.676555] PM: late suspend of devices complete after 26.714 msecs
> [ 1879.677144] ACPI: Preparing to enter system sleep state S3
> [ 1879.677144] Back to C!
> 
> Does anybody care?
> 
> mfg
> thomas

