Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0GJM6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 08:58:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab0GJM6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 08:58:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Bug #15673] 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Date: Sat, 10 Jul 2010 14:56:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera> <Hc02ROPrUsG.A.n-.nt7NMB@chimera> <1278751306.2955.3.camel@localhost.localdomain>
In-Reply-To: <1278751306.2955.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007101456.10876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 10, 2010, Thomas Meyer wrote:
> Am Samstag, den 10.07.2010, 02:33 +0200 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
> > Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2010-03-28 11:31 (104 days old)
> > Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
> > References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2
> 
> Still see the warning in 2.6.34.1:
> 
> [ 1466.091349] IMA: unmeasured files on fsmagic: 1021994
> [ 1466.091356] ima_dec_counts: open/free imbalance (r:0 w:-1 o:-1)
> [ 1466.091360] Pid: 2357, comm: async/10 Tainted: G        W  2.6.34.1 #3
> [ 1466.091362] Call Trace:
> [ 1466.091371]  [<c08865c7>] ? printk+0x1d/0x26
> [ 1466.091377]  [<c05f994f>] ima_file_free+0x16f/0x210
> [ 1466.091384]  [<c04d7742>] __fput+0xf2/0x1f0
> [ 1466.091388]  [<c04d785d>] fput+0x1d/0x30
> [ 1466.091394]  [<c06cad8f>] drm_gem_object_free_common+0x1f/0x40
> [ 1466.091398]  [<c06cae30>] ? drm_gem_object_free+0x0/0x40
> [ 1466.091402]  [<c06cae61>] drm_gem_object_free+0x31/0x40
> [ 1466.091407]  [<c061d59c>] kref_put+0x2c/0x60
> [ 1466.091412]  [<c06e7308>] i915_gem_cleanup_ringbuffer+0x48/0x70
> [ 1466.091416]  [<c06e8a6c>] i915_gem_idle+0x9c/0x120
> [ 1466.091420]  [<c06dbe1d>] i915_drm_freeze+0x3d/0xa0
> [ 1466.091423]  [<c06dbfde>] i915_pm_suspend+0x2e/0x80
> [ 1466.091427]  [<c0886d0a>] ? wait_for_common+0x1a/0xf0
> [ 1466.091432]  [<c0636629>] pci_pm_suspend+0x49/0x110
> [ 1466.091436]  [<c06365e0>] ? pci_pm_suspend+0x0/0x110
> [ 1466.091441]  [<c0718be1>] pm_op+0x181/0x1d0
> [ 1466.091445]  [<c0711d34>] ? device_for_each_child+0x54/0x60
> [ 1466.091449]  [<c071959f>] __device_suspend+0xbf/0x110
> [ 1466.091453]  [<c07199e3>] async_suspend+0x23/0x60
> [ 1466.091457]  [<c0450025>] async_thread+0xc5/0x210
> [ 1466.091461]  [<c0886931>] ? schedule+0x1e1/0x450
> [ 1466.091472]  [<c042bd60>] ? default_wake_function+0x0/0x20
> [ 1466.091476]  [<c044ff60>] ? async_thread+0x0/0x210
> [ 1466.091480]  [<c04493c4>] kthread+0x74/0x80
> [ 1466.091483]  [<c0449350>] ? kthread+0x0/0x80
> [ 1466.091488]  [<c040347e>] kernel_thread_helper+0x6/0x10
> [ 1466.096531] iint_free: writecount: -1
> [ 1466.096533] iint_free: opencount: -1
> [ 1466.096535] iint_free: writecount: -1
> [ 1466.096537] iint_free: opencount: -1
> [ 1466.103256] ehci_hcd 0000:00:1d.7: PCI INT A disabled

Thanks for the update.

Have you tried the current mainlne?

Rafael
