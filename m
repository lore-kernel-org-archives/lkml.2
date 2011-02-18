Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab1BSAA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:00:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758763Ab1BSAAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:19 -0500
Date: Fri, 18 Feb 2011 15:59:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 9/9] userns: check user namespace for task->file uid
 equivalence checks
Message-Id: <20110218155935.66e7782d.akpm@linux-foundation.org>
In-Reply-To: <20110217150406.GI26395@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150406.GI26395@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:04:07 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> Cheat for now and say all files belong to init_user_ns.  Next
> step will be to let superblocks belong to a user_ns, and derive
> inode_userns(inode) from inode->i_sb->s_user_ns.  Finally we'll
> introduce more flexible arrangements.
> 
>
> ...
>
> +
> +/*
> + * return 1 if current either has CAP_FOWNER to the
> + * file, or owns the file.
> + */
> +int is_owner_or_cap(const struct inode *inode)
> +{
> +	struct user_namespace *ns = inode_userns(inode);
> +
> +	if (current_user_ns() == ns && current_fsuid() == inode->i_uid)
> +		return 1;
> +	if (ns_capable(ns, CAP_FOWNER))
> +		return 1;
> +	return 0;
> +}

bool?

> +EXPORT_SYMBOL(is_owner_or_cap);

There's a fairly well adhered to convention that global symbols (and
often static symbols) have a prefix which identifies the subsystem to
which they belong.  This patchset rather scorns that convention.

Most of these identifiers are pretty obviously from the capability
subsystem, but still...

>
> ...
>

