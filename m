Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3AHSMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab3AHSML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:12:11 -0500
Date: Tue, 8 Jan 2013 13:12:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Message-ID: <20130108181205.GE29933@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-24-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-24-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:45PM -0800, Tejun Heo wrote:
> To support hierarchical stats, it's necessary to remember stats from
> dead children.  Add cfqg->dead_stats and make a dying cfqg transfer
> its stats to the parent's dead-stats.
> 
> The transfer happens form ->pd_offline_fn() and it is possible that
> there are some residual IOs completing afterwards.  Currently, we lose
> these stats.  Given that cgroup removal isn't a very high frequency
> operation and the amount of residual IOs on offline are likely to be
> nil or small, this shouldn't be a big deal and the complexity needed
> to handle residual IOs - another callback and rather elaborate
> synchronization to reach and lock the matching q - doesn't seem
> justified.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
