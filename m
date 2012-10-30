Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2J3KDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:55358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2J3KDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:03:01 -0400
Message-Id: <84c8a8$6b195m@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="212903094"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: drm i915 hangs on heavy io load
To: Norbert Preining <preining@logic.at>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <20121030003942.GC6539@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at> <eeac1e$4q1mqm@AZSMGA002.ch.intel.com> <20121030003942.GC6539@gamma.logic.tuwien.ac.at>
Date: Tue, 30 Oct 2012 10:02:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 09:39:43 +0900, Norbert Preining <preining@logic.at> wrote:
> Hi Chris,
> 
> On So, 28 Okt 2012, Chris Wilson wrote:
> > Yeah, looks like we have another issue to contend with, so can you
> > please file a bug on bugzilla.freedesktop.org (or bugzilla.kernel.org)
> > so that we don't lose track of it.
> 
> I have seen this here:
> 	https://bugs.freedesktop.org/show_bug.cgi?id=55984
> does it make sense to start a new bug for that?

I was fearing it was something different, but since Dave has now found
that rc6=0 was not sufficient in his case, it is probably the same. The
issue surrounding cpu-relocs was never explained and I suspect that we
are still being bitten by that root cause. Along those lines:

commit 86a1ee26bb60e1ab8984e92f0e9186c354670aed
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sat Aug 11 15:41:04 2012 +0100

    drm/i915: Only pwrite through the GTT if there is space in the aperture

is the most contentious patch in 3.7-rc.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
