Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2BQW5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:57:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33876 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2BQW5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:57:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.216.40 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 14:57:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217225735.GP29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217225125.GK26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Fri, Feb 17, 2012 at 05:51:26PM -0500, Vivek Goyal wrote:
> Otherwise on every IO, we will end up comparing submitting tasks's
> cgroup and cic/cfqq's cgroup.

But how much is that different from checking CHANGED bit on each IO?
I mean, we can just do sth like cfqg->blkg->blkcg == bio_blkcg(bio).
It isn't expensive.

> Also this will create problems, if two threads sharing io context are
> in two different cgroups. We will frequently end up changing the
> association.

blkcg doesn't allow that anyway (it tries but is racy) and I actually
was thinking about sending a RFC patch to kill CLONE_IO.

Thanks.

-- 
tejun
