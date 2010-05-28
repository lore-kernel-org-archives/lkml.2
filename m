Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab0E1Ekb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:40:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56031 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0E1Ek3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:40:29 -0400
Date: Thu, 27 May 2010 23:40:26 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] fs: block cross-uid sticky symlinks
Message-ID: <20100528044026.GA13636@us.ibm.com>
References: <20100527201635.GU6056@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527201635.GU6056@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user).  For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp

That is quite a list :)

> +int cap_inode_follow_link(struct dentry *dentry,
> +			  struct nameidata *nameidata)
> +{
> +	const struct inode *parent = dentry->d_parent->d_inode;
> +	const struct inode *inode = dentry->d_inode;
> +	const struct cred *cred = current_cred();
> +
> +	if (weak_sticky_symlinks)
> +		return 0;
> +
> +	if (S_ISLNK(inode->i_mode) &&

Q: is the S_ISLNK() check actually needed?

In either case:

Acked-by: Serge E. Hallyn <serue@us.ibm.com>

thanks,
-serge
