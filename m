Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0F3HFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:05:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:19487 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab0F3HFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:05:16 -0400
Message-Id: <89khjo$fr177d@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,510,1272870000"; 
   d="scan'208";a="531668205"
Date: Wed, 30 Jun 2010 08:05:08 +0100
To: Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
Cc: earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
       intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain> <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LFD.2.00.1001270738220.24253@localhost.localdomain> <89k77n$ms73l9@fmsmga001.fm.intel.com> <alpine.LFD.2.00.1001270917120.24253@localhost.localdomain> <AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 16:54:07 +1000, Dave Airlie <airlied@gmail.com> wrote:
> Chris's patch has been reported to cause a regression in hibernate,

Reviewing the patch again, we no longer set the default gfpmask on the
inode to contain NORETRY and instead add the NORETRY at the one spot in
the code where we are trying to do a large allocation and our shrinker
would be prevented from running (due to contention on struct_mutex).

I do not know how this causes memory corruption across hibernate and would
appreciate any insights.
-- 
Chris Wilson, Intel Open Source Technology Centre
