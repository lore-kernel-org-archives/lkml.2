Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab2BNJgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:36:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:47914 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759829Ab2BNJgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:36:08 -0500
Message-Id: <e39f63$3ncn6e@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125197518"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Fix single msg gmbus_xfers writes
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel@ffwll.ch>, Benson Leung <bleung@chromium.org>,
        keithp@keithp.com, airlied@linux.ie, djkurtz@chromium.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20120213222623.GN5301@phenom.ffwll.local>
References: <1328817797-4026-1-git-send-email-bleung@chromium.org> <20120213203838.GM5301@phenom.ffwll.local> <e0d58a$38gbj5@orsmga002.jf.intel.com> <20120213222623.GN5301@phenom.ffwll.local>
Date: Tue, 14 Feb 2012 09:35:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 23:26:23 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Mon, Feb 13, 2012 at 09:49:35PM +0000, Chris Wilson wrote:
> > On Mon, 13 Feb 2012 21:38:38 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> > However, the outstanding issue is that we need to separate the gmbus
> > i2c adapter from the gpio i2c adapter in order for the pairing to work
> > with the expectations of the i2c core.
> 
> There's another patch floating on dri-devel to add a gmbus_mutex. The
> issue it tries to avoid is that multiple users corrupting each anothers
> state when using the single gmbus controller. See "[PATCH] [PATCH]
> drm/i915: Fix race condition in accessing GMBUS". Or have you thought of
> another interaction that we need to sort out?

The GMBUS interface is currently disabled because we confused the i2c
core.
  https://bugzilla.kernel.org/show_bug.cgi?id=35572
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
