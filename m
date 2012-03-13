Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab2CMJhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:37:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48748
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760159Ab2CMJhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:37:21 -0400
Date: Tue, 13 Mar 2012 05:37:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 06/25] vfs: add i_op->atomic_create()
Message-ID: <20120313093720.GC11797@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-7-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331155362-11132-7-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:22:23PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new inode operation which is called on regular file create.  This is a
> replacement for ->create() which allows the file to be opened atomically with
> creation.
> 
> This function is also called for non-open creates (mknod(2)) with a NULL file
> argument.  Only one of ->create or ->atomic_create will be called, implementing
> both makes no sense.
> 
> The functionality of this method partially overlaps that of ->atomic_open().
> FUSE and 9P only use ->atomic_create, NFS, CIFS and CEPH use both.

I really don't like the special casing of the mknod handling in every
atomic_create instance.  Either we should keep ->create for it, or do a
cleanup pass before to always make that pass go through ->mknod - in
fact most filesystems handle the two in common code anyway so we might
be able to get rid of one of them, possible mkdir as well.
