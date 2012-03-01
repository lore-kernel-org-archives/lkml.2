Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2CAKO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:14:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:47256 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803Ab2CAKO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:14:28 -0500
Date: Thu, 1 Mar 2012 11:13:54 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] mm: dont set __GFP_WRITE on ramfs/sysfs writes
Message-ID: <20120301101354.GD1665@cmpxchg.org>
References: <20120228140022.614718843@intel.com>
 <20120228144747.440418051@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228144747.440418051@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:00:30PM +0800, Fengguang Wu wrote:
> Try to avoid page reclaim waits when writing to ramfs/sysfs etc.
> 
> Maybe not a big deal...

This looks like a separate fix that would make sense standalone.  It's
not just the waits, there is not much of a point in skipping zones
during allocation based on the dirty usage which they'll never
contribute to.  Could you maybe pull this up front?

> CC: Johannes Weiner <jweiner@redhat.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
