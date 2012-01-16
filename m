Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2APTez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:34:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2APTex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:34:53 -0500
Date: Mon, 16 Jan 2012 18:33:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v2 1/4] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
	from granting privs
Message-ID: <20120116173309.GA21112@redhat.com>
References: <cover.1326673414.git.luto@amacapital.net> <7bed6cc87d8f388269a73b1a9a4c9ebd6ac333da.1326673414.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bed6cc87d8f388269a73b1a9a4c9ebd6ac333da.1326673414.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Andy Lutomirski wrote:
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1117,6 +1117,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	if (retval < 0)
>  		goto bad_fork_free;
>
> +	p->no_new_privs = current->no_new_privs;

Again, this is unneeded, ->no_new_privs was copied by dup_task_struct().

Oleg.

