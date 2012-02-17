Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2BQWeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:34:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab2BQWeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:34:24 -0500
Date: Fri, 17 Feb 2012 17:34:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217223420.GJ26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217221406.GJ29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:14:06PM -0800, Tejun Heo wrote:

[..]
> If the associated blkcg is used consistently through block layer, it
> might be better but cfq doesn't even do that.  It has its own icq ->
> blkcg mapping, which it initializes on first cfqq association.  It
> even ignores tasks migrating to a different cgroup and keeps using
> whatever cgroup the task first issued IOs on. :(

Nope. We make note of task migration and drop cic->cfqq association
and establish a new association where new cfqq is part of new cgroup.
(ioc_cgroup_changed()).

In the past people have raised the issue of retaining the notion of
iopriority while dm targets are operating in between. This patchset
will help for that case.

Thanks
Vivek
