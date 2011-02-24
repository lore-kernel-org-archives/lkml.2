Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1BXDYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:24:04 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:55772
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932098Ab1BXDYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:24:02 -0500
Date: Thu, 24 Feb 2011 03:24:16 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 9/9] userns: check user namespace for task->file uid
 equivalence checks
Message-ID: <20110224032415.GA5555@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
 <20110217150406.GI26395@mail.hallyn.com>
 <20110218155935.66e7782d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218155935.66e7782d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Thu, 17 Feb 2011 15:04:07 +0000
> "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> > Cheat for now and say all files belong to init_user_ns.  Next
> > step will be to let superblocks belong to a user_ns, and derive
> > inode_userns(inode) from inode->i_sb->s_user_ns.  Finally we'll
> > introduce more flexible arrangements.
> > 
> >
> > ...
> >
> > +
> > +/*
> > + * return 1 if current either has CAP_FOWNER to the
> > + * file, or owns the file.
> > + */
> > +int is_owner_or_cap(const struct inode *inode)
> > +{
> > +	struct user_namespace *ns = inode_userns(inode);
> > +
> > +	if (current_user_ns() == ns && current_fsuid() == inode->i_uid)
> > +		return 1;
> > +	if (ns_capable(ns, CAP_FOWNER))
> > +		return 1;
> > +	return 0;
> > +}
> 
> bool?
> 
> > +EXPORT_SYMBOL(is_owner_or_cap);
> 
> There's a fairly well adhered to convention that global symbols (and
> often static symbols) have a prefix which identifies the subsystem to
> which they belong.  This patchset rather scorns that convention.
> 
> Most of these identifiers are pretty obviously from the capability
> subsystem, but still...

Would 'inode_owner_or_capable' be better and and make sense?

-serge
