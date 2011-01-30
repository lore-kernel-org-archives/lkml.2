Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1A3MZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:25:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:11635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1A3MZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:25:12 -0500
Message-Id: <0d30dc$ktil71@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,400,1291622400"; 
   d="scan'208";a="702108897"
Date: Sun, 30 Jan 2011 12:25:08 +0000
To: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Subject: Re: More display errors in 2.6.38-rc2-00175-g6fb1b30 (was 2.6.38-rc2-00175-g6fb1b30)
Cc: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20110128202905.GB3395@schottelius.org> <20110130103241.GA26556@schottelius.org> <849307$bc2lb2@azsmga001.ch.intel.com> <20110130120853.GA3979@schottelius.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110130120853.GA3979@schottelius.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jan 2011 13:08:53 +0100, Nico Schottelius <nico-kernel-20110117@schottelius.org> wrote:
> [10627.321357] i915 0000:00:02.0: power state changed by ACPI to D0
> [10627.321363] i915 0000:00:02.0: power state changed by ACPI to D0
> [10627.321369] i915 0000:00:02.0: setting latency timer to 64
> [10627.322724] sd 0:0:0:0: [sda] Starting disk
> [10627.345649] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 20425, limit 9000
> [10627.516702] [drm:ironlake_fdi_link_train] *ERROR* FDI train 1 fail!
> [10627.516862] [drm:ironlake_fdi_link_train] *ERROR* FDI train 2 fail!
> [10627.535575] usb 1-1.3: reset full speed USB device using ehci_hcd and address 3
> [10627.570055] [drm:ironlake_fdi_link_train] *ERROR* FDI train 1 fail!
> [10627.570215] [drm:ironlake_fdi_link_train] *ERROR* FDI train 2 fail!

So upon resume we fail to setup the connection between the CPU and PCH,
which would cause a broken display.

Now we haven't directly modified the FDI training in the .38 cycle, but we
have tweaked and enabled various power saving features for Ironlake that
have proven to be unstable in the past. (Hence why we had to disable them
but the obvious problems had been fixed...)

This should hopefully find the culprit:
$ git bisect start drivers/gpu/drm/i915/intel_display.c
$ git bisect good v2.6.37
$ git bisect bad

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
