Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2DJX3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:29:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:15846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab2DJX3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="130962371"
Date: Tue, 10 Apr 2012 16:29:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][REGRESSION] panic: fix stack dump print on direct call
 to panic()
Message-ID: <20120410232943.GB5656@tassilo.jf.intel.com>
References: <1333992030-21181-1-git-send-email-jason.wessel@windriver.com>
 <4F832BC8.4090907@linux.intel.com>
 <20120410121949.71145057.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410121949.71145057.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 12:19:49PM -0700, Andrew Morton wrote:
> On Mon, 09 Apr 2012 11:34:48 -0700
> Andi Kleen <ak@linux.intel.com> wrote:
> 
> > > The proper way to resolve the problem that original commit tried to
> > > solve is to avoid printing a stack dump from panic() when the either
> > > of the following conditions is true:
> > >
> > >    1) TAINT_DIE has been set (this is done by oops_end())
> > >       This indicates and oops has already been printed.
> > >    2) oops_in_progress>  1
> > >       This guards against the rare case where panic() is invoked
> > >       a second time, or in between oops_begin() and oops_end()
> > 
> > Oops. I guess can just revert it for now. Thanks for catching, Jason.
> 
> You're suggesting a revert of 6e6f0a1f0, but Jason is suggesting that
> it be repaired.  Confused.

Repairing is fine too for me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
