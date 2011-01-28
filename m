Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1A1Uq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:46:29 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53202 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1A1Uq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:46:28 -0500
Date: Fri, 28 Jan 2011 15:46:08 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: has the i915 "black screen" boot issue returned? [BISECTED]
In-Reply-To: <201101282112.52798.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1101281544050.2772@localhost6.localdomain6>
References: <alpine.DEB.2.00.1101260634300.10774@localhost6.localdomain6> <1bdc18$jdthb8@fmsmga002.fm.intel.com> <alpine.DEB.2.00.1101281006550.3007@localhost6.localdomain6> <201101282112.52798.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Rafael J. Wysocki wrote:

> Alternatively, you could take the vanilla Linus' tree and replace
> ioremap_cache() with ioremap() in include/linux/acpi_io.h .  Please
> try that and see if it makes a difference.

  as a quick followup, i applied the following simple patch:

$ git diff
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 64fd644..28adc6d 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -495,6 +495,8 @@ int intel_opregion_setup(struct drm_device *dev)
                opregion->acpi = base + OPREGION_ACPI_OFFSET;
        }

+return 0; // rday
+
        if (mboxes & MBOX_SWSCI) {
                DRM_DEBUG_DRIVER("SWSCI supported\n");
                opregion->swsci = base + OPREGION_SWSCI_OFFSET;


to the latest tree, and it gave me a booting kernel, no black screen
issue.  i will not pretend to understand why that fixes the problem
but it does.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
