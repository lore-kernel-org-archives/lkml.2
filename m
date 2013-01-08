Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3AHPvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:51:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3AHPvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:51:21 -0500
Date: Tue, 8 Jan 2013 10:51:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 12/24] cfq-iosched: implement cfq_group->nr_active and
 ->children_weight
Message-ID: <20130108155114.GC29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:34PM -0800, Tejun Heo wrote:
> To prepare for blkcg hierarchy support, add cfqg->nr_active and
> ->children_weight.  cfqg->nr_active counts the number of active cfqgs
> at the cfqg's level and ->children_weight is sum of weights of those
> cfqgs.  The level covers itself (cfqg->leaf_weight) and immediate
> children.
> 
> The two values are updated when a cfqg enters and leaves the group
> service tree.  Unless the hierarchy is very deep, the added overhead
> should be negligible.
> 
> Currently, the parent is determined using cfqg_flat_parent() which
> makes the root cfqg the parent of all other cfqgs.  This is to make
> the transition to hierarchy-aware scheduling gradual.  Scheduling
> logic will be converted to use cfqg->children_weight without actually
> changing the behavior.  When everything is ready,
> blkcg_weight_parent() will be replaced with proper parent function.
> 
> This patch doesn't introduce any behavior chagne.
> 
> v2: s/cfqg->level_weight/cfqg->children_weight/ as per Vivek.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
