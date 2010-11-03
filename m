Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0KCKAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:00:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0KCKAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:00:16 -0400
Date: Wed, 3 Nov 2010 10:00:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: sfrench@samba.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/1] FS: cifs, remove unneeded NULL tests
Message-ID: <20101103100012.GA19804@ZenIV.linux.org.uk>
References: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 04:08:55PM +0100, Jiri Slaby wrote:
> Stanse found that pSMBFile in cifs_ioctl and file->f_path.dentry in
> cifs_user_write are dereferenced prior their test to NULL.

file->f_path.dentry is never NULL for an opened file, neither is
file->f_path.dentry->d_inode (which cannot change for the entire
lifetime of dentry, BTW).  IOW,

> -	/* since the write may have blocked check these pointers again */
> -	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
> -		struct inode *inode = file->f_path.dentry->d_inode;

in there had always been junk.  So yes, losing these tests is the right
thing to do.
