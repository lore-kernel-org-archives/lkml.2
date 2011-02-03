Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1BCMyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:54:11 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:59065 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1BCMyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:54:10 -0500
Date: Thu, 3 Feb 2011 13:53:57 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/2] memcg: clean up limit checking
Message-ID: <20110203125357.GA2286@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
 <1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
 <20110131144131.6733aa3a.akpm@linux-foundation.org>
 <20110201000455.GB19534@cmpxchg.org>
 <20110131162448.e791f0ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131162448.e791f0ae.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:24:48PM -0800, Andrew Morton wrote:
> On Tue, 1 Feb 2011 01:04:55 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Maybe it would be better to use res_counter_margin(cnt) >= wanted
> > throughout the code.
> 
> yup.

Okay, I cleaned it all up a bit for .39.  While doing so, I also found
that we are reclaiming one page too much when pushing back on behalf
of soft limits.

So 1/2 fixes the soft limit reclaim off-by-one-page, and 2/2 reduces
all the limit checks to two functions.
