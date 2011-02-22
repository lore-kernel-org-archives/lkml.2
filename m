Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1BVUaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:30:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60372 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1BVUaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:30:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=HuX2t/QwyzKRBVuKZX6J1qFsEfGv+hGx7sHpAZYd8WHavw/xl/I5BlUzyxLgtysO6q
         7O9M6/jMNN25aztp0E+ilQYNZmcszYR4PIJ+6mLmxN+qR9BpN4o6TeNgko/+YpFnyWta
         Ikco3rwQSJiw5u3uYr7XSzSYq+XvzFL438UUc=
Date: Tue, 22 Feb 2011 23:29:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110222202915.GC1966@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <gregkh@suse.de>, Kees Cook <kees.cook@canonical.com>,
	linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
	Ralph Campbell <infinipath@qlogic.com>,
	Roland Dreier <roland@kernel.org>,
	Sean Hefty <sean.hefty@intel.com>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Neil Brown <neilb@suse.de>, Matthew Wilcox <matthew@wil.cx>,
	James Morris <jmorris@namei.org>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
	Arnd Bergmann <arnd@arndb.de>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
	Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <20110222191333.GA9991@suse.de>
 <20110222192248.GX4000@outflux.net>
 <20110222193314.GA11033@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222193314.GA11033@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:33:14AM -0800, Greg KH wrote:
> Again, let's fix the real problems here, world-writable debugfs files.

We could just ban them?

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e7a7a2f..03ae095 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -223,6 +223,9 @@ struct dentry *debugfs_create_file(const char *name, mode_t mode,
 
 	pr_debug("debugfs: creating file '%s'\n",name);
 
+	/* don't allow world writable files */
+	mode &= ~S_IWOTH;
+
 	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
 			      &debugfs_mount_count);
 	if (error)


