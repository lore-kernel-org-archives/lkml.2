Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2CZNa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:30:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34227
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756172Ab2CZNa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:30:57 -0400
Date: Mon, 26 Mar 2012 09:30:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 03/25] vfs: split __dentry_open()
Message-ID: <20120326133028.GA8436@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-4-git-send-email-miklos@szeredi.hu>
 <20120324141251.GA25980@infradead.org>
 <CAJfpegu8byHvPk3_KM3f1HE0dyaytVtsjZcUH5RB4pfwbQHEYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu8byHvPk3_KM3f1HE0dyaytVtsjZcUH5RB4pfwbQHEYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 03:22:09PM +0200, Miklos Szeredi wrote:
> > I think the O_DIRECT checks should move out of the VFS. ??The direct I/O
> > method isn't called from the VFS anywhere, but just from the
> > generic_file_* routines in filemap.c, which suggest doing the O_DIRECT
> > check in there as well.
> 
> Returning the error at the earliest opportunity (from open as opposed
> to read/write) makes sense.  Given that some apps may actually rely on
> the return value from open to verify O_DIRECT support, it doesn't seem
> to be a good idea to move the checks to read/write.

I'm fine with keeping it in open, bu it should be in generic_file_open,
not in the VFS (and yeah, generic_file_open is in open.c not filemap.c
where it should be, sorry)

