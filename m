Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2BIJju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:39:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60942 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2BIJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:39:47 -0500
Date: Thu, 9 Feb 2012 13:35:04 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Colin Walters <walters@verbum.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
Message-ID: <20120209093504.GA19507@albatros>
References: <cover.1327858005.git.luto@amacapital.net>
 <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
 <1327960736.5355.5.camel@lenny>
 <1327961884.5882.11.camel@gandalf.stny.rr.com>
 <CABqD9habGczrDUxGUWpRQ1=bREjCx-6rPeYArnGXe76fW3K2zw@mail.gmail.com>
 <CALCETrX6xRCvkHBz0TKVxffgOFRfvnb7ZbmyiN3zruwgBXjhKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX6xRCvkHBz0TKVxffgOFRfvnb7ZbmyiN3zruwgBXjhKw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 14:51 -0800, Andy Lutomirski wrote:
> That's neat!  CLONE_NEWPID might be safe with no_new_privs, too.
> Unprivileged CLONE_NEWPID would also be a nice, straightforward way to
> start up a process hierarchy and then reliably kill the whole thing
> when you're done with it.

It worth checking whether creating HUGE number or pid namespaces is
able to lock down the system for a significant period of time.  E.g.
triggering thousands of pid_ns enumeration under a spinlock.

The same with every "enable this privileged feature to unprivileged
users under certain circumstances" step.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
