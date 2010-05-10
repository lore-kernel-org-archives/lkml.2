Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0EJQwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:52:44 -0400
Received: from www17.your-server.de ([213.133.104.17]:55820 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab0EJQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:52:41 -0400
X-Greylist: delayed 2009 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 12:52:40 EDT
Subject: Re: [Bug #15673] 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <HqroMXsT-CJ.A.d6F.w-y5LB@chimera>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
	 <HqroMXsT-CJ.A.d6F.w-y5LB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 18:18:44 +0200
Message-ID: <1273508324.2241.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 09.05.2010, 23:17 +0200 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
> Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2010-03-28 11:31 (43 days old)
> Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
> References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2
> 
> 

I still see this message in 2.6.34-rc7:

[  252.947229] sd 0:0:0:0: [sda] Stopping disk
[  252.998073] atl1c 0000:01:00.0: PCI INT A disabled
[  252.998353] uhci_hcd 0000:00:1d.2: PCI INT D disabled
[  252.998364] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  252.998374] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  252.998436] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  252.998481] ACPI handle has no context!
[  252.998505] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  252.998521] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  252.998582] IMA: unmeasured files on fsmagic: 1021994
[  252.998585] ima_dec_counts: open/free imbalance (r:0 w:-1 o:-1)
[  252.998590] Pid: 2509, comm: async/10 Tainted: G        W  2.6.34-rc7 #102
[  252.998592] Call Trace:
[  252.998601]  [<c08860a5>] ? printk+0x1d/0x20
[  252.998608]  [<c05f98af>] ima_file_free+0x16f/0x210
[  252.998615]  [<c04d7722>] __fput+0xf2/0x1f0
[  252.998619]  [<c04d783d>] fput+0x1d/0x30
[  252.998631]  [<c06cad0f>] drm_gem_object_free_common+0x1f/0x40
[  252.998636]  [<c06cadb0>] ? drm_gem_object_free+0x0/0x40
[  252.998640]  [<c06cade1>] drm_gem_object_free+0x31/0x40
[  252.998645]  [<c061d4dc>] kref_put+0x2c/0x60
[  252.998650]  [<c06e7288>] i915_gem_cleanup_ringbuffer+0x48/0x70
[  252.998654]  [<c06e89ec>] i915_gem_idle+0x9c/0x120
[  252.998658]  [<c06dbdad>] i915_drm_freeze+0x3d/0xa0
[  252.998662]  [<c06dbf6e>] i915_pm_suspend+0x2e/0x80
[  252.998666]  [<c08867ea>] ? wait_for_common+0x1a/0xf0
[  252.998671]  [<c0636569>] pci_pm_suspend+0x49/0x110
[  252.998676]  [<c0636520>] ? pci_pm_suspend+0x0/0x110
[  252.998680]  [<c0718ac1>] pm_op+0x181/0x1d0
[  252.998685]  [<c0711c24>] ? device_for_each_child+0x54/0x60
[  252.998689]  [<c071947f>] __device_suspend+0xbf/0x110
[  252.998693]  [<c07198c3>] async_suspend+0x23/0x60
[  252.998697]  [<c0450005>] async_thread+0xc5/0x210
[  252.998701]  [<c0886411>] ? schedule+0x1e1/0x450
[  252.998706]  [<c042bd50>] ? default_wake_function+0x0/0x20
[  252.998709]  [<c044ff40>] ? async_thread+0x0/0x210
[  252.998714]  [<c04493a4>] kthread+0x74/0x80
[  252.998717]  [<c0449330>] ? kthread+0x0/0x80
[  252.998721]  [<c040347e>] kernel_thread_helper+0x6/0x10
[  253.003324] iint_free: writecount: -1
[  253.003327] iint_free: opencount: -1
[  253.003329] iint_free: writecount: -1
[  253.003331] iint_free: opencount: -1
[  253.010040] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  253.696666] PM: suspend of devices complete after 749.760 msecs
[  253.723385] PM: late suspend of devices complete after 26.714 msecs
[  253.723979] ACPI: Preparing to enter system sleep state S3
[  253.723979] Back to C!


