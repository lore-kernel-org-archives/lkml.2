Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2AQQbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2AQQbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:31:12 -0500
Date: Tue, 17 Jan 2012 17:23:09 +0100
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
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
Message-ID: <20120117162309.GA16336@redhat.com>
References: <cover.1326673414.git.luto@amacapital.net> <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Andy Lutomirski wrote:
>
> Chroot can easily be used to subvert setuid programs.  If no_new_privs,
> then setuid programs don't gain any privilege, so allow chroot.
>
> ...
>
> +	if (!(current->no_new_privs && !is_chrooted) &&
> +	    !capable(CAP_SYS_CHROOT))

I must have missed something. How no_new_privs can help if fs->users != 1 ?

Oleg.

