Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1G2TCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:02:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:7070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1G2TCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:02:33 -0400
Message-Id: <e0d58a$uf843@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,288,1309762800"; 
   d="scan'208";a="31957123"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915 SSC Patch
To: Keith Packard <keithp@keithp.com>, Ben Brewer <ben.brewer@codethink.co.uk>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <yunwrf1gc3b.fsf@aiko.keithp.com>
References: <4E32ADC7.3080002@codethink.co.uk> <yunwrf1gc3b.fsf@aiko.keithp.com>
Date: Fri, 29 Jul 2011 20:02:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 11:45:28 -0700, Keith Packard <keithp@keithp.com> wrote:
Non-text part: multipart/signed
> On Fri, 29 Jul 2011 13:55:35 +0100, Ben Brewer <ben.brewer@codethink.co.uk> wrote:
> 
> > I've added a global SSC (Spread Spectrum Clock) parameter to the i915 
> > driver, since having SSC enabled breaks (distorts) VGA output on some 
> > Core i5/i7 chips (see https://bugs.freedesktop.org/show_bug.cgi?id=38750).
> > SSC is still enabled by default so the behaviour won't change but 
> > setting the global_use_ssc parameter will turn this feature off and 
> > allow affected devices to function correctly (notably the Dell Vostro
> > 3300).
> 
> The question I have is why is SSC enabled on the VGA output at all? I
> don't see any way VGA could ever tolerate it.

It's not meant to be and it causes havoc, from wavy/blurry output to no
sync. The other part of the patch on that bug was to walk the crtcs and
turn off SSC on the shared refclk if any output could not handle SSC. At
that point, an objection was raised that we shouldn't even be touching
the refclk if any output was currently being driven from it.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
