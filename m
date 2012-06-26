Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2FZPvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:51:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42964
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880Ab2FZPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:51:20 -0400
Date: Tue, 26 Jun 2012 11:51:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tj@kernel.org, hch@infradead.org,
        jmoyer@redhat.com, vgoyal@redhat.com, dm-devel@redhat.com
Subject: Re: [RFC PATCH] block: all callers should check blkdev_issue_flush's
 return
Message-ID: <20120626155115.GA17242@infradead.org>
References: <1340724445-3314-1-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340724445-3314-1-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:27:25AM -0400, Mike Snitzer wrote:
> It is concerning that a FLUSH may fail but the blkdev_issue_flush
> callers assume it will always succeed.
> 
> Each blkdev_issue_flush caller should come to terms with the reality
> that a FLUSH may fail -- the file_operations' .fsync methods in
> particular.  nilfs2 is the only filesystem that checks
> blkdev_issue_flush's return.

Good spot, but it would be way better if you actually provided patches
to fix this instead of just adding more compiler warnings.

