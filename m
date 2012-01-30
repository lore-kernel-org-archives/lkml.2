Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2A3BrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:47:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2A3BrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:47:08 -0500
Date: Sun, 29 Jan 2012 17:47:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Message-ID: <20120130014703.GG17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
 <20120129192447.GB17211@htj.dyndns.org>
 <4F25F5F3.6060507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F25F5F3.6060507@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:44:19AM +0900, Namhyung Kim wrote:
> The userland tool cannot distinguish bounced bio from original one
> at completion TP, but it can expect there will be a duplicated
> BLK_TA_COMPLETE as it sees BLK_TA_BOUNCE for the bio before.
> 
> Filtering it out from kernel side seems to hide a real information
> that (paranoid?) user might want to get, and it looks like providing
> "polcy not mechanism" IMHO. That's why I changed my mind finally.
> 
> I cannot think of the downside, anyway it's not a big deal, if you
> think it's wrong choice, I'm OK to change it again.

It's just that this patch as it stands will break the existing tools
and is likely to cause some amount of head scratching for blktrace
users upgrading to new kernel with existing userland, so yeah, I think
it should be filtered in kernel from blktrace.c.

Thanks.

-- 
tejun
