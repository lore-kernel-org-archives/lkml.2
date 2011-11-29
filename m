Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1K2PgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:36:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:64416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1K2PgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:36:16 -0500
Message-Id: <c55c5d$185nps@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,591,1315206000"; 
   d="scan'208";a="42131260"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/2] drm/i915: properly clflush pwrites to phys objects
To: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org
In-Reply-To: <1322579369-26954-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1322579369-26954-1-git-send-email-daniel.vetter@ffwll.ch> <1322579369-26954-2-git-send-email-daniel.vetter@ffwll.ch>
Date: Tue, 29 Nov 2011 15:35:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 16:09:29 +0100, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Usually results in (rare) cursor corruptions on platforms
> requiring physically addressed cursors.

So the phys cursor pages are set to WC upon creation, are we just
missing the mb()? Or more likely the CPUs don't have PAT and we are
being lazy in not detecting the error.

Anyway as this is reported to fix the issue on 8xx at least, overkill
is fine. :)

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
