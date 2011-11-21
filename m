Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1KUQVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:21:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53993 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1KUQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:21:50 -0500
Date: Mon, 21 Nov 2011 17:23:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
Message-ID: <20111121162306.GB3807@phenom.ffwll.local>
Mail-Followup-To: Rakib Mullick <rakib.mullick@gmail.com>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Keith Packard <keithp@keithp.com>
References: <1321382968.8791.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321382968.8791.4.camel@localhost.localdomain>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 12:49:28AM +0600, Rakib Mullick wrote:
> 
> A call to i915_add_request() has been made in function i915_gem_busy_ioctl(). i915_add_request can fail,
> so in it's exit path previously allocated memory needs to be freed.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Indeed, nice catch (albeit totally unlikely to be hit, because the error
only happens when the gpu ceases to progress in the ring, so imo not
stable material). Keith, please pick this up for fixes, thanks.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
