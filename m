Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0ITSKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:10:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:65381 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0ITSKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:10:17 -0400
Message-Id: <89k83a$9ngpbu@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,395,1280732400"; 
   d="scan'208";a="326657406"
Date: Mon, 20 Sep 2010 19:10:12 +0100
To: Shawn Starr <shawn.starr@rogers.com>, linux-kernel@vger.kernel.org
Subject: Re: [i915] 2.6.36-rc4-git2 (Fedora snapshot) - kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1444!
References: <650240.84760.qm@smtp101.rog.mail.re2.yahoo.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <650240.84760.qm@smtp101.rog.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 01:23:41 -0400, Shawn Starr <shawn.starr@rogers.com> wrote:
> I've been hitting this repeatedly in using this kernel this is a recent issue. Also, www.kerneloops.org seems broken, someone might want to fix this? We can disregard virtualbox drivers causing this especially given the 
> traceback.

I think I understand what is happening here: we are missing a holding a
reference for the object on the eviction list and so it is being
prematurely freed. I think I have a fix, but I've only just arrived back
from Toulouse and haven't yet begun testing the -fixes branch.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
