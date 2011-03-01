Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1CAWc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:32:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:14547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab1CAWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:32:27 -0500
Message-Id: <1bdc18$jo39ki@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,249,1297065600"; 
   d="scan'208";a="662808210"
Date: Tue, 01 Mar 2011 22:32:24 +0000
To: Jan Niehusmann <jan@gondor.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: fix memory corruption with GM965 and >4GB RAM
References: <20110223233022.GA3439@x61s.reliablesolutions.de> <20110225123056.GA3759@x61s.reliablesolutions.de> <b9dded$i2gkhr@orsmga002.jf.intel.com> <20110225211646.GA6837@x61s.reliablesolutions.de> <b9dded$i2hik6@orsmga002.jf.intel.com> <20110225230527.GC3601@viiv.ffwll.ch> <20110301222416.GA3526@x61s.reliablesolutions.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110301222416.GA3526@x61s.reliablesolutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 23:24:16 +0100, Jan Niehusmann <jan@gondor.com> wrote:
> Indeed, setting dma_alloc_coherent should be sufficient, AFAIKT. After
> all, only the HWS seems to be affected, which is allocated with
> drm_pci_alloc, which in turn uses dma_alloc_coherent.
> 
> I just tried the patch below, it also works for me (as expected). Added
> the comment because otherwise it wouldn't be obvious why the mask gets
> set to 32 bit.
> 
> What I don't know is if really only Broadwater and Crestline chips are
> affected. The tests were done with a Crestline one. But I think it's a
> fair guess that the bug would have been noticed earlier if more recent
> chips were affected, as >4GB RAM have become much more common since then.

The later chips do not use a physical address for the hardware status
page. The patch looks good, thanks.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
