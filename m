Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2BCVr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:47:26 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58211 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755695Ab2BCVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:47:24 -0500
Date: Fri, 3 Feb 2012 13:47:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203214719.GE14209@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
 <20120203205910.GB14209@google.com>
 <20120203214435.GC12616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203214435.GC12616@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:44:35PM -0500, Vivek Goyal wrote:
> Ok, looks like now it is needed because blkcg lock will just gurantee that
> blkg is around but blkg->pd[plid] can disappear if you are not holding
> blkio_list lock (update_root_blkgs).
> 
> I am wondering if we should take blkcg->lock if blkg is on blkcg list and
> is being modified in place. That way, once we are switching elevator,
> we should be able to shoot down the policy data without taking blkio_list
> lock.

I think it gotta become something per-queue, not global, and if we
make it per-queue, it should be able to live inside queue_lock.

Thanks.

-- 
tejun
