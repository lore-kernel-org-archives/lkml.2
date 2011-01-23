Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1AWU7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 15:59:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:2077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1AWU7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 15:59:01 -0500
Message-Id: <849307$b97gn8@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,366,1291622400"; 
   d="scan'208";a="378782440"
Date: Sun, 23 Jan 2011 20:58:56 +0000
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/1] Use cachable mapping for i915 opregion.
Cc: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1295803414-5373-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de> <0d30dc$kr9u7e@orsmga001.jf.intel.com> <201101232152.27970.rjw@sisk.pl>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201101232152.27970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 21:52:27 +0100, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Sunday, January 23, 2011, Chris Wilson wrote:
> > On Sun, 23 Jan 2011 18:23:34 +0100, Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> wrote:
> > > The opregion is a shared memory region between ACPI and the graphics
> > > driver. As the ACPI mapping has been changed to cachable in commit
> > > 6d5bbf00d251cc73223a71422d69e069dc2e0b8d, mapping the intel opregion
> > > non-cachable now fails. As no bus-master hardware is involved in the
> > > opregion, cachable map should do no harm.
> > 
> > Satisfied myself that is indeed equivalent to use the newly introduced
> > acpi_os_ioremap for this purpose and applied to -fixes.
> 
> However, it might be better to use acpi_os_ioremap() in case we decide to
> go back to ioremap() for some reason.  For now, ioremap_cache() seems fine,
> but ...

Great minds think a like, but fools rarely differ...
http://git.kernel.org/?p=linux/kernel/git/ickle/drm-intel.git;a=commit;h=94b3eb7a71fe62f19c91c39dd94c83786108d626
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
