Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0IERVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 13:21:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:15336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0IERVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 13:21:15 -0400
Message-Id: <89k83a$9i7dn6@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,321,1280732400"; 
   d="scan'208";a="321107686"
Date: Sun, 05 Sep 2010 18:21:10 +0100
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org> <89k83a$9hv9li@azsmga001.ch.intel.com> <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com> <alpine.LSU.2.00.1009041244440.3044@sister.anvils> <87vd6ls0jd.fsf@turtle.gmx.de> <4C83C124.8050408@kernel.org> <8u3s8d$jg1fmi@orsmga001.jf.intel.com> <AANLkTikjBztwp5rcGKGWc_6DLkFu5CTXAbePTbjEfyML@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTikjBztwp5rcGKGWc_6DLkFu5CTXAbePTbjEfyML@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Sep 2010 19:40:06 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> The "drm-intel" branch on top of 2.6.36-rc3 works OK on my machine. I
> do see the following errors in dmesg but they seem to be harmless:
> 
> [    1.004937] render error detected, EIR: 0x00000010
> [    1.004981] page table error
> [    1.005018]   PGTBL_ER: 0x00000102
> [    1.005058] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
> 0x00000010, masking
> [    1.005139] render error detected, EIR: 0x00000010
> [    1.005194] page table error
> [    1.005244]   PGTBL_ER: 0x00000102

Do you see this on 2.6.36-rc3 as well? I had thought we had seen the last
of those. lspci would be useful to know precisely which chipset is
throwing that error.

> [    1.660043] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
> plane, expect flickering: entries required = 36, available = 31.

These are based on a pessimistic guess for the memory latency and so
we overestimate the number of FIFO entries required to avoid underruns.
All that has changed is that we now print out the warning and have been
surprised by how far out our estimation has been. We first need to find
some way of improving our estimate for the memory latency and so trim the
watermarks. And under the circumstances where we need more entries than
are available on one pipe, we need to adjust the FIFO configuration.

In the short term, we will need to quieten the "harmless" error message.

I've lost track of the current status for releasing the documentation for
gen2/3. As always, it should be ready real soon now. 
-- 
Chris Wilson, Intel Open Source Technology Centre
