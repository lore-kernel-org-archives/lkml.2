Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2BQW4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:56:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2BQW4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:56:19 -0500
Date: Fri, 17 Feb 2012 17:56:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217225615.GL26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217224103.GN29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:41:03PM -0800, Tejun Heo wrote:
> On Fri, Feb 17, 2012 at 05:34:20PM -0500, Vivek Goyal wrote:
> > Nope. We make note of task migration and drop cic->cfqq association
> > and establish a new association where new cfqq is part of new cgroup.
> > (ioc_cgroup_changed()).
> 
> Yeah, that's the CHANGED bit thing.  I probably got confused with
> blk-throttle losing blkcg while testing.

BTW, blk-throttle mangling the context, is a real problem you are facing
or it is just one of things which is nice to fix. If a cgroup is being
throttled do people really care about the iopriority of original task
that much. (Given the fact that iopriority helps only so much and kills
performance on fast storage).

Thanks
Vivek
