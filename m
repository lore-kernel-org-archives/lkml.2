Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab1BPWMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:12:13 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:40728 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754010Ab1BPWMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:12:12 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Thu, 17 Feb 2011 11:12:06 +1300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ryan@bluewatersys.com, akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102100722.47854.manningc2@actrix.gen.nz> <20110216080419.GA21261@infradead.org>
In-Reply-To: <20110216080419.GA21261@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102171112.07101.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chrisoph

On Wednesday 16 February 2011 21:04:20 Christoph Hellwig wrote:
> On Thu, Feb 10, 2011 at 07:22:47AM +1300, Charles Manning wrote:
> > Can you be a bit more specific?
>
> Just compare the mes in yaffs_linux.c with a normal linux filesystem.
> All that gross magic nfsd detection in readdir could have been removed
> long ago.  ->readlink should not be implemented by a normal filesystem
> but use generic_readlink,

Fair comment. I'm sure there are better ways to handle that.

> the fs-specific inode should embedd the vfs 
> inode instead of requiring two allocations,

The approach used here significantly reduces memory footprint. 
The yaffs inodes (== yaffs objects) live all the time while the vfs inodes 
come and go. It is far better to just link these together when in use.

> tons of useless function 
> pointer indirections like sb_dirty_fn and the put_super_fn really must
> go away.  

Ok.

> The procfs interfaces should be replaced by something saner, 
> the insane amount of ad-hoc tracing crap should be replaced by much
> less strategically placed trace events, and all those stupid compile
> time options have absolutely no business at all beeing there for a
> filesystem - 

Why not?

> remember you can get media from all over the place. 

No you can't. This is a flash file system for soldered down flash. I think 
that is a fundamental place where your understanding of what yaffs is falls 
down.

> If you can't encode these difference in your on-disk format it has
> absolutely no business going into mainline with this format.

Yaffs does not really have an on-disk format like most other fs do.

> And last but not least there's no way we'll merge a filesystem with a
> global mutex and all kinds of hacky release and reaquire semantics
> these days. 

I could change the locking but that would require considerable work.

> I really think you need to get back to the drawing board. 

I'm starting to think that the distance from where yaffs is now to what people 
will accept into the kernel tree might be quite large.

I might just be easier to walk away from the mainlining effort. Yaffs is a 
highly successful and useful fs and very easy to patch in to a kernel. People 
could continue to use it that way as they have for the last 9 ears or so.

-- Charles



