Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1LHMUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:20:00 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57474 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1LHMT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:19:58 -0500
Date: Thu, 8 Dec 2011 05:19:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][patch series] vfsmount gutting
Message-ID: <20111208121956.GX4387@parisc-linux.org>
References: <20111208010251.GF2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208010251.GF2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 01:02:52AM +0000, Al Viro wrote:
> 	OK, that's something I wanted to do for a long time - struct vfsmount
> contains too much stuff that is strictily VFS-internal and not needed by
> anything outside of a very small subset of VFS, at that.  As the matter of
> fact, only 3 fields, 1 of them redundant, are used by code outside of that
> area - it's mnt_flags ("how it's mounted"), mnt_root ("what dentry tree
> is mounted here", assign-once thing) and mnt_sb (always equal to
> mnt_root->d_sb, also assign-once, might or might not be not needed).

If only these 3 fields are used, why not make the definition of struct
vfsmount entirely hidden, and add accessor functions for those three?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
