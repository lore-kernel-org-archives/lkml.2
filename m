Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1BTW2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 17:28:48 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:57803
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755221Ab1BTW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 17:28:47 -0500
Date: Sun, 20 Feb 2011 22:28:53 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch added
 to -mm tree
Message-ID: <20110220222853.GA2960@mail.hallyn.com>
References: <20110219165409.GA2712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110219165409.GA2712@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> > Subject: userns: add a user_namespace as creator/owner of uts_namespace
> > From: "Serge E. Hallyn" <serge@hallyn.com>
> 
> Minor nit... feel free to ignore, but can't resist.
> 
> --- a/kernel/nsproxy.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
> +++ a/kernel/nsproxy.c
> @@ -74,6 +74,11 @@ static struct nsproxy *create_new_namesp
>  		err = PTR_ERR(new_nsp->uts_ns);
>  		goto out_uts;
>  	}
> +	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
> +		put_user_ns(new_nsp->uts_ns->user_ns);
> +		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
> +		get_user_ns(new_nsp->uts_ns->user_ns);
> +	}
> 
> Looks correct, but confusing imho.
> 
> "new_nsp->uts_ns != tsk->nsproxy->uts_ns" is a bit strange way to
> check "flags & CLONE_NEWUTS", no?
> 
> And since copy_utsname() already checks CLONE_NEWUTS, can't we move
> this code into copy_utsname() or clone_uts_ns() ?

Yup.  I had only found the bug this addresses very late so sort of
felt I should keep it as an obvious band-aid for now.  I've got a
lot of feedback to address on this set (!), and I'll do this more
cleanly as well.

Thanks for taking a look, Oleg.

-serge
