Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2LMWlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:41:24 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52021 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753421Ab2LMWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:41:23 -0500
Date: Thu, 13 Dec 2012 16:41:19 -0600
From: Ben Myers <bpm@sgi.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS corruption on post 3.7 tree.
Message-ID: <20121213224119.GU30652@sgi.com>
References: <20121213205522.GA28455@redhat.com>
 <20121213221057.GA22049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213221057.GA22049@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Thu, Dec 13, 2012 at 05:10:57PM -0500, Dave Jones wrote:
> On Thu, Dec 13, 2012 at 03:55:22PM -0500, Dave Jones wrote:
>  > Doing a kernel build while running on a 3.7+ tree from last night and I hit this...
>  > 
>  > 
>  > [22637.787422] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 163 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa070086a

Looks like the dir v2 verifier found that a single block directory had a data
entry without a corresponding leaf entry in the block.

> I unmounted, remounted, unmounted, and then ran xfs_repair on it, as prompted.
> xfs_repair noted..
> 
> bad hash table for directory inode 201328949 (bad stale count): rebuilding

Interesting!
								
> After remounting, things seemed ok again.
> I blew away my .ccache on that drive, and restarted my compile,
> and then hit the same bug again.

Suppose you could you grab a metadump before repairing it next time?  

Regards,
	Ben
