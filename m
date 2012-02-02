Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2BBWHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:07:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab2BBWHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:07:19 -0500
Date: Thu, 2 Feb 2012 17:07:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] blkcg: move refcnt to blkcg core
Message-ID: <20120202220714.GE1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328131156-13290-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:19:11PM -0800, Tejun Heo wrote:
> Currently, blkcg policy implementations manage blkg refcnt duplicating
> mostly identical code in both policies.  This patch moves refcnt to
> blkg and let blkcg core handle refcnt and freeing of blkgs.
> 
> * cfq blkgs now also get freed via RCU.

This can lead to situation where cfq root group (policy data) is still
around (yet to be freed after rcu perioed) but cfq has gone away
(cfq_exit_queue() followed by cfq_exit()). Does it matter? If some future
code is accessing cfqg under rcu, it can become a problem.

Thanks
Vivek
