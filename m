Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab2JWJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:18:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:52514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab2JWJSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:18:18 -0400
Message-Id: <6c3329$6sai31@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,634,1344236400"; 
   d="scan'208";a="231032929"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: drm i915 hangs on heavy io load
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Norbert Preining <preining@logic.at>
In-Reply-To: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
Date: Tue, 23 Oct 2012 10:17:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 14:38:30 +0900, Norbert Preining <preining@logic.at> wrote:
> Hi everyone,
> 
> (please Cc)
> 
> I am running 3.7-rc2 and got recently hit a few times (under rc1, too)
> by hanging drm i915 while doing large io operations.
[snip]
> 
> I captured the i915_error_state and uploaded it here:
> 	http://www.logic.at/people/preining/drm_i915_error_state.gz
> 
> The hangs have been normally initiated on svn up in a very big
> repository, or git checkout on a very big repository or so.
> 
> Other system is Debian/unstable. The above output and error state is
> from after a reboot without any suspends or other tricks inbetween,
> uptime 3.5h.

Looks like fallout from a missing ILK rc6 workaround - it looks like the
write to the ring tail never landed and so the command streamer hung.

See https://bugs.freedesktop.org/show_bug.cgi?id=55984 and
http://cgit.freedesktop.org/~danvet/drm/log/?h=ilk-wa-pile of which I
think
http://cgit.freedesktop.org/~danvet/drm/commit/?h=ilk-wa-pile&id=0d5fed2de763b49bb1a90140758153481f043757
is the missing ingredient.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
