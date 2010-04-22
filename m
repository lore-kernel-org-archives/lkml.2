Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0DVFzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:55:07 -0400
Received: from lazybastard.de ([212.112.238.170]:58619 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0DVFzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:55:04 -0400
Date: Thu, 22 Apr 2010 07:54:48 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422055448.GA27309@logfs.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100419102056.GS27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 April 2010 12:20:56 +0200, Jens Axboe wrote:
> 
> Thanks, we definitely should have put a debug statement to catch this in
> from day 1, good debugging should be an important part of any new
> infrastructure.

Woke up early and had another look at this.  Looks like a much more
widespread problem.  Based on a quick grep an uncaffeinated brain:

9p	no s_bdi
afs	no s_bdi
ceph	creates its own s_bdi
cifs	no s_bdi
coda	no s_bdi
ecryptfs no s_bdi
exofs	no s_bdi
fuse	creates its own s_bdi?
gfs2	creates its own s_bdi?
jffs2	patch exists
logfs	fixed now
ncpfs	no s_bdi
nfs	creates its own s_bdi
ocfs2	no s_bdi
smbfs	no s_bdi
ubifs	creates its own s_bdi

I excluded all filesystems that appear to be read-only, block device
based or lack any sort of backing store.  So there is a chance I have
missed some as well.

Jörn

-- 
Simplicity is prerequisite for reliability.
-- Edsger W. Dijkstra
