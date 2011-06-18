Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1FRPox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:44:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1FRPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=j0dM3rpmHbVZlqNIHviYrQ+NvWtvxco8CaNM4mBr6HdNgIJ7IQ/fo45qj/bV+bVBt6
         9gzO3YBPh2oG+1jUvk9Q==
Date: Sat, 18 Jun 2011 08:44:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
In-Reply-To: <20110618081134.fbafed0f.rdunlap@xenotime.net>
Message-ID: <alpine.LSU.2.00.1106180841310.1261@sister.anvils>
References: <alpine.DEB.2.02.1106181108210.3831@localhost6.localdomain6> <20110618081134.fbafed0f.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011, Randy Dunlap wrote:
> On Sat, 18 Jun 2011 11:10:20 -0400 (EDT) Robert P. J. Day wrote:
> 
> > 
> > Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
> > deselect the TMPFS_POSIX_ACL config variable.
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Yes, that's good, Robert, thanks - I'm glad I left the writing to you.

Acked-by: Hugh Dickins <hughd@google.com>

> 
> 
> > ---
> > 
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index 19891aa..4217543 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -127,14 +127,20 @@ config TMPFS_POSIX_ACL
> >  	select TMPFS_XATTR
> >  	select GENERIC_ACL
> >  	help
> > -	  POSIX Access Control Lists (ACLs) support permissions for users and
> > -	  groups beyond the owner/group/world scheme.
> > +	  POSIX Access Control Lists (ACLs) support additional access rights
> > +	  for users and groups beyond the standard owner/group/world scheme,
> > +	  and this option selects support for ACLs specifically for tmpfs
> > +	  filesystems.
> > +
> > +	  If you've selected TMPFS, you almost certainly want this option
> > +	  as well since a number of user space features (e.g., ALSA sound)
> > +	  require POSIX ACL support under /dev to work properly.  In other
> > +	  words, if you're not sure and you have no *compelling* reason to
> > +	  deselect this feature, say Y.
> > 
> >  	  To learn more about Access Control Lists, visit the POSIX ACLs for
> >  	  Linux website <http://acl.bestbits.at/>.
> > 
> > -	  If you don't know what Access Control Lists are, say N.
> > -
> >  config TMPFS_XATTR
> >  	bool "Tmpfs extended attributes"
> >  	depends on TMPFS
> > 
> > -- 
