Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3AHQmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:42:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab3AHQmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:42:35 -0500
Date: Tue, 8 Jan 2013 11:42:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 14/24] cfq-iosched: convert cfq_group_slice() to use
 cfqg->vfraction
Message-ID: <20130108164226.GE29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:36PM -0800, Tejun Heo wrote:
> cfq_group_slice() calculates slice by taking a fraction of
> cfq_target_latency according to the ratio of cfqg->weight against
> service_tree->total_weight.  This currently works only because all
> cfqgs are treated to be at the same level.
> 
> To prepare for proper hierarchy support, convert cfq_group_slice() to
> base the calculation on cfqg->vfraction.  As cfqg->vfraction is always
> a fraction of 1 and represents the fraction allocated to the cfqg with
> hierarchy considered, the slice can be simply calculated by
> multiplying cfqg->vfraction to cfq_target_latency (with fixed point
> shift factored in).
> 
> As vfraction calculation currently treats all non-root cfqgs as
> children of the root cfqg, this patch doesn't introduce noticeable
> behavior difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
