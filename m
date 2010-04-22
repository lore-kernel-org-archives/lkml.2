Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0DVLzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:55:52 -0400
Received: from lazybastard.de ([212.112.238.170]:38543 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab0DVLzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:55:51 -0400
Date: Thu, 22 Apr 2010 13:55:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422115539.GE27309@logfs.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422090303.GA27497@kernel.dk> <20100422103953.GB27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422103953.GB27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 April 2010 12:39:53 +0200, Jens Axboe wrote:
> 
> Here's a series for fixing these. At this point they are totally
> untested except that I did compile them. Note that your analysis
> appeared correct for all cases but ocfs2, which does use get_sb_bdev()
> and hence gets ->s_bdi assigned.
> 
> You can see them here, I'll post the series soon:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus
> 
> The first patch is a helper addition, the rest are per-fs fixups.

Looks good at a cursory glance.  What's still missing is some sort of
assertion.  You are a smart person and missed this problem, twice even.
Even if you hadn't, a not so smart person can add a new filesystem and
miss s_bdi, like I did.  We want some automatism to catch this.

Jörn

-- 
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
