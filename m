Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2H0Ems (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 00:42:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37424 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2H0Emq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 00:42:46 -0400
Date: Sun, 26 Aug 2012 21:42:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 08/32] drm/i915: correctly order the ring init sequence
Message-ID: <20120827044242.GA1874@kroah.com>
References: <20120820035647.862247088@linuxfoundation.org>
 <20120820035649.020303468@linuxfoundation.org>
 <20120824230313.GD3072@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824230313.GD3072@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 08:03:14PM -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, Aug 19, 2012 at 08:57:04PM -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> > commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.
> > 
> > We may only start to set up the new register values after having
> > confirmed that the ring is truely off. Otherwise the hw might lose the
> > newly written register values. This is caught later on in the init
> > sequence, when we check whether the register writes have stuck.
> > 
> > Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
> > Tested-by: Yang Guang <guang.a.yang@intel.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I think with this commit also the following commits should be picked for
> 3.4 right? (as suggested for 3.0):
> 
> f01db988ef6f6c70a6cc36ee71e4a98a68901229
> b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6
> 
> Just reporting that I tested this 3.4.10 proposed update with the two
> commits above cherry-picked/backported applied, and worked ok.

3.4.10 as-is works fine for me, so I'm a bit leary of wanting to add
more patches to it (or 3.0.42), until I get some kind of confirmation
that these two patches are really needed.

Anyone else having problems here?

thanks,

greg k-h
