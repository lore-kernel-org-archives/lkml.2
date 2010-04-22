Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0DVMRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 08:17:13 -0400
Received: from lazybastard.de ([212.112.238.170]:53890 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab0DVMRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 08:17:12 -0400
Date: Thu, 22 Apr 2010 14:17:02 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422121702.GG27309@logfs.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422090303.GA27497@kernel.dk> <20100422103953.GB27497@kernel.dk> <20100422115539.GE27309@logfs.org> <20100422120837.GE27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422120837.GE27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 April 2010 14:08:37 +0200, Jens Axboe wrote:
> 
> I totally agree, we want some way to catch this problem in the future.
> Really the check needs to be something ala:
> 
>         if (!sb->s_bdi && mnt_has_storage_backing() && rw_mount)
>                 yell_and_fail;
> 
> but I'm not sure how best to accomplish that. We can check for ->s_bdev
> and mtd like you did, but that does not catch network file systems for
> instance.

One way would be to either add a flag to all safe filesystems or create
a noop_bdi for them.  It adds a line of code and some bytes[*] per
instance to most filesystems, but that's the only catchall I can think
of.

I guess if noone comes up with a better plan I'll look into that.

[*] Maybe we can steal a bit somewhere to make it less expensive.

Jörn

-- 
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
