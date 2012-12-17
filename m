Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2LQVSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2LQVSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:18:50 -0500
Date: Mon, 17 Dec 2012 16:18:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 06/12] cfq-iosched: implement cfq_group->nr_active and
 ->level_weight
Message-ID: <20121217211843.GA13691@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-7-git-send-email-tj@kernel.org>
 <20121217204609.GH7235@redhat.com>
 <20121217211517.GC1844@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217211517.GC1844@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:15:17PM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Mon, Dec 17, 2012 at 03:46:09PM -0500, Vivek Goyal wrote:
> > On Fri, Dec 14, 2012 at 02:41:19PM -0800, Tejun Heo wrote:
> > > To prepare for blkcg hierarchy support, add cfqg->nr_active and
> > > ->level_weight.  cfqg->nr_active counts the number of active cfqgs at
> > > the cfqg's level and ->level_weight is sum of weights of those cfqgs.
> > > The level covers itself (cfqg->leaf_weight) and immediate children.
> > 
> > This notion of level is really confusing. If one says "at cfqg's level"
> > I immediately associate with cfqg's siblings and not with cfqg's children.
> 
> We can explicitly say at children's level but I think it should be
> enough to explain it clearly in the comment where the field is
> defined.
> 
> > I think confusion happens because we are overloading the definition of
> > cfqg. It is competing with its siblings at the same time it is competing
> > against its child groups (on behalf of its children tasks).
> 
> While I agree that part is a bit tricky, I can't think of a much
> better way to describe it.  Any better ideas?

Can we call it cfqg->children_weight insted of cfqg->level_weight.


Thanks
Vivek
