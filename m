Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1LAQVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:21:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41752 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1LAQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:21:07 -0500
Date: Thu, 1 Dec 2011 17:22:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Slaby <jslaby@suse.cz>
Cc: daniel@ffwll.ch, Keith Packard <keithp@keithp.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Jiri Slaby <jirislaby@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: g33: tiled output
Message-ID: <20111201162231.GB4291@phenom.ffwll.local>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org, Jiri Slaby <jirislaby@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <4ED79138.5060703@suse.cz>
 <20111201154249.GA4291@phenom.ffwll.local>
 <4ED7A213.3010900@suse.cz>
 <4ED7A4C9.601@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED7A4C9.601@suse.cz>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 05:01:13PM +0100, Jiri Slaby wrote:
> On 12/01/2011 04:49 PM, Jiri Slaby wrote:
> > On 12/01/2011 04:42 PM, Daniel Vetter wrote:
> >> On Thu, Dec 01, 2011 at 03:37:44PM +0100, Jiri Slaby wrote:
> >>> For some time, I'm seeing a tiled output like:
> >>> http://www.fi.muni.cz/~xslaby/sklad/panics/bad_tile.png
> >>>
> >>> This happens sometimes when I open selected pages in firefox. Like
> >>> maps above.
> >>>
> >>> Currently I'm running 3.2.0-rc3-next-20111130. This started appearing
> >>> after I switched to desktop fx. Will anything from the debugfs help to
> >>> track this down? Or better to report this to freedesktop.org?
> >>
> >> Please test the patch Chris already replied with to your first mail. It
> >> might fix your issue here (if it's just a fence being stolen a bit too
> >> early). If that does not help, I'll have to stare at the picture some more
> >> to decode the type of tiling/swizzling going on. Maybe different pictures
> >> of corruptions might help for that.
> 
> More of them:
> http://www.fi.muni.cz/~xslaby/sklad/panics/bad_tile1.png
> http://www.fi.muni.cz/~xslaby/sklad/panics/bad_tile2.png
> http://www.fi.muni.cz/~xslaby/sklad/panics/bad_tile3.png

Something is pretty decently broken here. Can you please file a bug at
freedesktop.org against the i915 drm? A few other things
- Can you check whether upgrading the ddx to 2.17 fixes this? Also please
  attach your Xorg.log and full dmesg.
- Please grab intel-gpu-tools.git from

http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/

  and attach the output of tools/intel_reg_dumper to the bug report.
- If you're using swap, can you check whether disabling it works around
  the issue?

And please put me as the assignee of the bug.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
