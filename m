Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0J2SS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:18:27 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:58809 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0J2SSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:18:25 -0400
Date: Fri, 29 Oct 2010 14:18:04 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Lee@kernel.org, Chun-Yi <joeyli.kernel@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: Tree for October 28 (acpi_video)
In-reply-to: <20101029090131.68709a71.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.2.00.1010291406560.3423@localhost.localdomain>
References: <20101028142031.5a4d6612.sfr@canb.auug.org.au>
 <20101029090131.68709a71.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/built-in.o: In function `acpi_video_bus_put_one_device':
> video.c:(.text+0x9d794): undefined reference to `backlight_device_unregister'

Invalid .config, as ACPI_VIDEO depends on BACKLIGHT_CLASS_DEVICE, which is not set.

This breakage is the infamous "select in Kconfig doesn't" bug,
which has apparently claimed a new victim, STUB_POULSBO:

(STUB_POULSBO && HAS_IOMEM && PCI && ACPI || DRM_I915 && <choice> && 
AGP_INTEL && ACPI || DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && 
DRM && PCI && ACPI) selects ACPI_VIDEO which has unmet direct dependencies 
(ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT)

commit e26fd1199ebab0d469fc3e037da5932d382f0669
Author: Lee, Chun-Yi <joeyli.kernel@gmail.com>
Date:   Wed Oct 20 13:51:19 2010 +0800

    gpu: Add Intel GMA500(Poulsbo) Stub Driver
    
    Currently, there have no GMA500(Poulsbo) native video driver to 
support
    intel opregion. So, use this stub driver to enable the acpi backlight
    control sysfs entry files by requrest acpi_video_register.
    
    [airlied: fix warnings]
    
    Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

