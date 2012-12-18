Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2LRTWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:22:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53936 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2LRTWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:22:01 -0500
Date: Tue, 18 Dec 2012 11:21:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 12/12] cfq-iosched: add hierarchical cfq_group statistics
Message-ID: <20121218192155.GQ1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-13-git-send-email-tj@kernel.org>
 <20121218191117.GD24050@redhat.com>
 <20121218191425.GO1844@htj.dyndns.org>
 <20121218191854.GB25908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218191854.GB25908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:18:54PM -0500, Vivek Goyal wrote:
> > Yeah, hmmm, maybe we should add another set of counters to carry stats
> > from dead ones?  Avoiding hierarchical accounting overhead in hot path
> > while remembering by-gones shouldn't be that hard.  Will work on that.
> 
> So are you planning to migrate the stats to parent when a cgroup is being
> deleted?  That should make sure we don't do hierarhical update.

Yeah, something like that.  The current statistics being !hierarchical
means that we need to keep them separate from the actual stats, so
it'll end up with another set of stats.  Kinda nasty but I don't see
any better way out.

Thanks.

-- 
tejun
