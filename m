Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0KHJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:16:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:8708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab0KHJQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:16:57 -0500
Message-Id: <0d30dc$k407g6@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="675290630"
Date: Mon, 08 Nov 2010 09:16:50 +0000
To: Adrian Bono <adrian.bono@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.36 oops in intel_ring_advance() (i915/DRM) when running opengl programs
In-Reply-To: <AANLkTi=BKkfWFt=Une0mggm_=X_VpfhT4g8Nt=cAnFqj@mail.gmail.com>
References: <AANLkTi=BKkfWFt=Une0mggm_=X_VpfhT4g8Nt=cAnFqj@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 16:56:30 +0800, Adrian Bono <adrian.bono@gmail.com> wrote:
> I tested 2.6.36 on an Asus laptop with an Intel GM965 chipset. I first
> noticed the oops when i tried to run Virtualbox, which links to
> opengl, and i tried reproducing it with glxgears, which it
> consistently does.

There are two bugs at play here. The first is a broken userspace driver
causing a GPU hang. The second is that kernel hasn't noticed the hang,
tries to advance the CS ringbuffer, times out, ignores the error and
writes to beyond the end of the mapped region. There's a fix for the
latter in drm-intel-next, and it's likely that the GL bug has been
fixed in the few years since you last updated. At very least, I have a
better chance at diagnosing what went wrong with a GEM based driver.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
