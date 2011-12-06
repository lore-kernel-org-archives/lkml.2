Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1LFRnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:43:25 -0500
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:57902
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1LFRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:43:24 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Date: Tue, 6 Dec 2011 09:43:17 -0800
From: Ben Widawsky <ben@bwidawsk.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: fix infinite recursion on unbind
 due to ilk vt-d w/a
Message-ID: <20111206174317.GB32563@bolo_yeung.jf.intel.com>
References: <1323169953-7697-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323169953-7697-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 12:12:33PM +0100, Daniel Vetter wrote:
> The recursion loop goes retire_requests->unbind->gpu_idle->retire_reqeusts.
> 
> Every time we go through this we need a
> - active object that can be retired
> - and there are no other references to that object than the one from
>   the active list, so that it gets unbound and freed immediately.
> Otherwise the recursion stops. So the recursion is only limited by the
> number of objects that fit these requirements sitting in the active list
> any time retire_request is called.
> 
> Issue exercised by tests/gem_unref_active_buffers from i-g-t.
> 
> There's been a decent bikeshed discussion whether it wouldn't be
> better to pass around a flag, but imo this is o.k. for such a limited
> case that only supports a w/a.
> 
> Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Chris Wilson <chris@chris-wilson> # we built better
> 	bikesheds, but this keeps the rain off for now
> ---

What about:
http://lists.freedesktop.org/archives/intel-gfx/2011-October/012984.html


Did someone prove that doesn't work?
