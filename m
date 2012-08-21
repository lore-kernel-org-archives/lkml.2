Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2HUFN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 01:13:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2HUFN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 01:13:27 -0400
Date: Tue, 21 Aug 2012 02:13:19 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 04/16] drm/i915: correctly order the ring init sequence
Message-ID: <20120821051318.GB3625@herton-Z68MA-D2H-B3>
References: <20120820035457.653002510@linuxfoundation.org>
 <20120820035458.292084336@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820035458.292084336@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 08:56:03PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.
> 
> We may only start to set up the new register values after having
> confirmed that the ring is truely off. Otherwise the hw might lose the
> newly written register values. This is caught later on in the init
> sequence, when we check whether the register writes have stuck.
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
> Tested-by: Yang Guang <guang.a.yang@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

I had the same problem as on 3.2 with this change, i915 stopped working
unable to initialize render ring, eg. on one of the boots here:
[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f003 head 00001020 tail 00000000 start 00001000 

But unlike I was expecting as with 3.2 case, picking commit
f01db988ef6f6c70a6cc36ee71e4a98a68901229 ("drm/i915: Add wait_for in
init_ring_common") here isn't enough, it continues to fail even if I
try to increase the delay in the wait_for, I'm not sure why yet... may
be something else is going on, or 3.0 has something else missing.

Also the same proposed patch for 3.4.10 gives the same problem, but
picking f01db988ef6f6c70a6cc36ee71e4a98a68901229 there made things work
again like happend on first 3.2.28 proposed update. Only 3.0
is misteriously failing either way here.

-- 
[]'s
Herton
