Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0KSQmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:42:43 -0500
Received: from fieldses.org ([174.143.236.118]:34577 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab0KSQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:42:40 -0500
Date: Fri, 19 Nov 2010 11:42:36 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: David Quigley <merlin@countercultured.net>
Cc: Eric Paris <eparis@redhat.com>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>, Steve French <sfrench@samba.org>
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias
Message-ID: <20101119164236.GA29148@fieldses.org>
References: <1290016263-1637-1-git-send-email-josef@redhat.com>
 <20101117191817.GA26575@fieldses.org>
 <20101117192822.GB3818@localhost.localdomain>
 <20101117202617.GA31009@fieldses.org>
 <1290031941.14282.101.camel@localhost.localdomain>
 <4CE60AE9.2070101@countercultured.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE60AE9.2070101@countercultured.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:28:09AM -0500, David Quigley wrote:
> [snip]
> >If you have persistent xattr support we need the dentry since the xattr
> >code requires a dentry.  I have no idea why but that's what
> >inode->i_op->getxattr() requires.
> >
> 
> The original reason that the xattr operations take dentries is
> because of p9fs and CIFS. CIFS uses the name of the file to grab the
> extended attributes and so does p9fs. I had tried to remove this a
> while ago but couldn't find a way around that.

Both CIFS and FUSE are NFS-exportable, so both allow lookup by
filehandle, so neither can count on getting a filename at this point.

So, out of curiosity, do we know what will happen when selinux asks one
of them for an xattr on a DCACHE_DISCONNECTED dentry?

> When trying to find a
> solution I also got push back from Miklos (FUSE) as he views a
> filesystem being able to make xattr decisions based on the path name
> being a valid use-case.

So selinux may initialize an inode differently depending on which
pathname it happened to be looked up under first?

Factoring the name into the xattr return sounds scary to me.

--b.
