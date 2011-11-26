Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1KZQxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 11:53:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:37101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab1KZQxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 11:53:35 -0500
Message-Id: <aefc95$2cas5k@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="80048308"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, akpm@linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CADZ9YHinT6Y98Ks6Zs3UnG2xQSJYqDN5W1RgrNtyaPz-n8Zajg@mail.gmail.com>
References: <1321382968.8791.4.camel@localhost.localdomain> <20111121162306.GB3807@phenom.ffwll.local> <868vn9ieey.fsf@sumi.keithp.com> <CADZ9YHgwcjz=mkMxWxV1pT7fH=6hgWTSP1s2wmG7h3N837QUoQ@mail.gmail.com> <e0d58a$2cdsbh@orsmga002.jf.intel.com> <CADZ9YHinT6Y98Ks6Zs3UnG2xQSJYqDN5W1RgrNtyaPz-n8Zajg@mail.gmail.com>
Date: Sat, 26 Nov 2011 16:53:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Nov 2011 22:29:12 +0600, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> Yes, no real problem with current code. I was just thinking from code
> cleanup's pov. Is BUG_ON really needed in i915_add_request() ?

No, just documentation as a reminder that the request should be
preallocated, ideally so that we can fail gracefully without touching
hardware and leaving it in an inconsistent state wrt to our bookkeeping.
(This is more apparent in the overlay code which could hang the
chip/driver if we hit a malloc error too late.)

The BUG_ON has certainly outlived its usefulness.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
