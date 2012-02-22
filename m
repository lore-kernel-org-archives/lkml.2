Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2BVTH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:07:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37215 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2BVTHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:07:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.125.133 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Wed, 22 Feb 2012 11:07:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 34/36] block: implement bio_associate_current()
Message-ID: <20120222190750.GA17480@google.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <1329875223-5102-35-git-send-email-tj@kernel.org>
 <x49linvyobl.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49linvyobl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Jeff.

On Wed, Feb 22, 2012 at 08:45:02AM -0500, Jeff Moyer wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > -v2: #ifdef CONFIG_BLK_CGROUP added around bio->bi_ioc dereference in
> >      rq_ioc() to fix build breakage.
> 
> This is useful for cfq without blk cgroups as well, right?  Why have you
> limited the scope like this?

Because blk-throttle is the only current user.  We can move the
BLK_CGROUP to cover just bi_css later on as we add more users.

Thanks.

-- 
tejun
