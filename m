Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0CWPJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:09:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57218 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0CWPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:09:24 -0400
Date: Tue, 23 Mar 2010 15:09:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
Message-ID: <20100323150923.GI30031@ZenIV.linux.org.uk>
References: <20100323142200.GA2381@localhost.localdomain>
 <20100323142843.GG30031@ZenIV.linux.org.uk>
 <20100323143456.GC2381@localhost.localdomain>
 <20100323144828.GH30031@ZenIV.linux.org.uk>
 <20100323150301.GD2381@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323150301.GD2381@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:03:01AM -0400, Josef Bacik wrote:
> > sb is an active reference
> > 
> 
> I don't understand how this is an active reference?  We are talking about
> s_active right?

It's an opened file, for crying out loud!  If there is anything that makes
sure that superblock will stay alive, that is it...

And lose the "locked" argument, please.  The sane solution is to make
get_active_super() return it unlocked and have your freeze_bdev() simply
grab s_umount.  Unconditionally.  I'll do the first part in #untested in
a minute or so (and make it grab s_umount in the current variant of code in
fs/block_dev.c); then your patch would shift taking s_umount down into
freeze_super().
