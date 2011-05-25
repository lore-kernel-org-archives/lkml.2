Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1EYJdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:33:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1EYJdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:33:10 -0400
Date: Wed, 25 May 2011 10:33:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bob Liu <lliubbo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: vfs: where is get_sb_single()?
Message-ID: <20110525093308.GA11521@ZenIV.linux.org.uk>
References: <BANLkTin0GwQYc+fAgSSFcsVysOPfxrin0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin0GwQYc+fAgSSFcsVysOPfxrin0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 03:19:58PM +0800, Bob Liu wrote:
> Hi, folks
> 
> I found that fs/super.c doesn't have get_sb_single() anymore.
> 
> But I can't find the git log which delete that function.
> Some out of tree file systems depends on that function.

The same out of tree filesystems depend on ->get_sb() being there...
See Documentation/filesystems/porting:

[mandatory]
        ->get_sb() is gone.  Switch to use of ->mount().  Typically it's just
a matter of switching from calling get_sb_... to mount_... and changing the
function type.  If you were doing it manually, just switch from setting ->mnt_root
to some pointer to returning that pointer.  On errors return ERR_PTR(...).

IOW, odds are good that you'll need to do something like what had been
done in commit 152a08366671080f27b32e0c411ad620c5f88b57 - not terribly
complicated.
