Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab0IMG7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:59:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0IMG7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:59:39 -0400
Date: Mon, 13 Sep 2010 16:59:22 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, hch@infradead.org,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        npiggin@kernel.dk, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle
 syscalls
Message-ID: <20100913165922.09dc60dc@notabene>
In-Reply-To: <E1Ov26Q-0000Hd-IT@pomaz-ex.szeredi.hu>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<m31v95zweh.fsf@linux.vnet.ibm.com>
	<E1OswT5-000709-U9@pomaz-ex.szeredi.hu>
	<m3d3spvhdn.fsf@linux.vnet.ibm.com>
	<E1OsyA1-0007Ct-KS@pomaz-ex.szeredi.hu>
	<m3r5gyepho.fsf@linux.vnet.ibm.com>
	<E1Ov26Q-0000Hd-IT@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 08:01:18 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Mon, 13 Sep 2010, Aneesh Kumar K. V wrote:
> > As per your suggestion i started looking at handlefs details and below
> > is my take on the approach.
> > 
> > handlefs would be an internal kernel mount like pipefs and would have
> > inode object mapping to the returned file descriptor of
> > open_by_handle_at syscall for symlinks. For regular files we can do what
> > we already does and for symlinks we will create inodes in handlefs and
> > their inode operation will in turn result in call out of inode operations
> > of the actual symlinks. Based on the above
> > 
> > a) We still need open_by_handle_at syscall
> > b) We still need handle based link syscall, because we need to support
> >    creating hardlinks based on handle, and the existing linkat syscall
> >    takes the oldpath name.
> > c) We still need handle based readlink syscall, because the existing
> >    readlinkat syscall takes pathname.
> 
> You can implement ->read() on the symlink file instead.

I would suggest that is a much uglier hack than changed readlinkat to accept
a NULL pathname.

NeilBrown


> 
> > d) we can drop stat, chown and xattr syscall because they are introduced
> >    specially for symlinks as we don't allow open on symlinks.
> > e) It would be nice to have handle based stat syscall to avoid two
> >    syscall overhead for fetching file attributes when implementing a
> >    file server, where fetching file attribute is a common operation. 
> 
> Syscall overhead is generally insignificant compared to other effects.
> The server can also cache open files for commonly used handles.
> 
> > 
> > With the above from the current patch series we can drop chown and
> > xattr syscalls. Would it be ok if we get the series with the those two
> > syscall patches dropped upstream as i work on supporting symlinks with
> > handlefs approach ?
> 
> Try it.
> 
> Al seems to only be active to the outside world around the merge
> window, so that's the best time to ask him to pull.
> 
> Thanks,
> Miklos

