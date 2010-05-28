Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0E1Bvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:51:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57802 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0E1Bvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:51:48 -0400
Date: Fri, 28 May 2010 02:51:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20100528015145.GI31073@ZenIV.linux.org.uk>
References: <20100528114539.012ff1d2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528114539.012ff1d2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 11:45:39AM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/platforms/cell/spufs/file.c:1852: error: expected ';', ',' or ')' before 'int'
> arch/powerpc/platforms/cell/spufs/file.c:1871: error: 'spufs_mfc_fsync' undeclared here (not in a function)

Tpyo in fsync patch (missing comma in line 1852 there)

> Caused by commit 05b2fc7d1f1046fef1199e1a4d2f63df998ef3aa ("drop unused
> dentry argument to ->fsync").
 
> My merge of the vfs tree was also bad because commit
> facd07b07d2a7988f5ce849558838cc953847637 ("direct-io: add a hook for the
> fs to provide its own submit_bio function") that entered Linus' tree in
> the past 24 hours changed the prototype of __blockdev_direct_IO() and
> that probably needs reflecting in the new __blockdev_direct_IO_newtrunc().

OK, I'll rebase that stuff.
