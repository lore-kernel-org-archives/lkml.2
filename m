Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0HXIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:16:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:6978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0HXIQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:16:53 -0400
Message-Id: <8u3s8d$jcg467@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,262,1280732400"; 
   d="scan'208";a="650645703"
Date: Tue, 24 Aug 2010 09:16:50 +0100
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [REGRESSION, i915]: Periodic stalls with 2.6.36-rc2
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com> <20100824075741.GA11000@sucs.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100824075741.GA11000@sucs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 08:57:41 +0100, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> The stalls became a bit better with the patch but there were still very
> small pauses but the tearing with more recent X bits is definitely still
> there. Additionally videos in totem would play as a tiny one pixel high
> row about a quarter of the screen across at the top left of the screen.
> It also seems that X has started having trouble refreshing itself so
> sometimes new windows are invisible (especially with compiz).

Ok, I'm a little happier that the hangcheck could be just another symptom
of the problem...

I think it is safe to assume that the bug is in i915, so restricting the
bisect to just drm seems plausible:

git bisect start drivers/gpu/drm
git bisect good 2.6.36-rc1
git bisect bad 2.6.36-rc2

And yes, it does apppear that the false detection rate for TV has changed.
The suspicion is that the change to intel_wait_for_vblank() is actually
causing issues here.

-- 
Chris Wilson, Intel Open Source Technology Centre
