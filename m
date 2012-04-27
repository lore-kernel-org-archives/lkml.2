Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2D0OrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:47:15 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60015 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969Ab2D0OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:47:14 -0400
Date: Fri, 27 Apr 2012 07:47:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 02/11] blkcg: __blkg_lookup_create() doesn't have to
 fail on radix tree preload failure
Message-ID: <20120427144709.GJ27486@google.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-3-git-send-email-tj@kernel.org>
 <20120427144258.GI10579@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427144258.GI10579@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 10:42:58AM -0400, Vivek Goyal wrote:
> On Thu, Apr 26, 2012 at 02:59:12PM -0700, Tejun Heo wrote:
> > __blkg_lookup_create() currently fails if radix_tree_preload() fails;
> > however, preload failrue doesn't imply insertion failure.  Don't fail
> > __blkg_lookup_create() on preload failure.
> > 
> 
> If we are going to try the insertion anyway irrespective of the fact
> whether preload succeeded or not, they why call radix_tree_preload()
> at all? How does that help?

Hmmm... it seems I originally misread radix_tree_node_alloc() - I
thought it didn't go through kmem_cache_alloc() if gfp_mask didn't
contain __GFP_WAIT.  If we don't use more permissible GFP flag during
preloading there's no point in preloading.  Will drop it.

Thanks.

-- 
tejun
