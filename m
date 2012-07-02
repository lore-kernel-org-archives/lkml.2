Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2GBV5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:57:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:65218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab2GBV5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187683573"
Date: Mon, 2 Jul 2012 14:57:22 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
Message-ID: <20120702215722.GC14479@tassilo.jf.intel.com>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
 <1341254598-1379-3-git-send-email-andi@firstfloor.org>
 <1341256733.23484.11.camel@twins>
 <20120702195744.GG11413@one.firstfloor.org>
 <1341260540.23484.25.camel@twins>
 <20120702210008.GB14479@tassilo.jf.intel.com>
 <1341265014.23484.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341265014.23484.47.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 11:36:54PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-07-02 at 14:00 -0700, Andi Kleen wrote:
> > Ok so you want a new flag? Or a new event?
> 
> Once we grow the sysfs event stuff for cpu PMUs, we could add a new
> named event, but I don't think its all that important.
> 
> instructions isn't all that interesting a measure to sample. And the
> people that do care can already use it by filling out the event
> manually.

The idea was to make it easier to use, similar to the recent
automatic IBS setup on AMD.

It's the nearest you can get on Intel systems.

I agree it would be nicer on cycles, but instructions are in many
cases a reasonable approximation.

BTW the problem with specifying it manually is that there
is no way to enforce the SandyBridge quiescence restrictions. 
It would probably need forking the tables too and removing it on 
SandyBridge, or something special to enforce exclusive mode,
all complicated and ugly.

An explicit way to specify it side steps that all nicely.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
