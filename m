Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2LFHDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:03:52 -0500
Received: from ozlabs.org ([203.10.76.45]:55814 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2LFHDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:03:50 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [PULL] (Was Re: [PATCH 3.7-rc8] lib/Makefile: Fix oid_registry build dependency)
In-Reply-To: <1354650748-11032-1-git-send-email-tim.gardner@canonical.com>
References: <1354650748-11032-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 06 Dec 2012 17:32:19 +1030
Message-ID: <87k3svfytg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> writes:
> It is $(obj)/oid_registry.o that is dependent on $(obj)/oid_registry_data.c.
> The object file cannot be built until $(obj)/oid_registry_data.c has been
> generated.
>
> A periodic and hard to reproduce parallel build failure is due to
> this incorrect lib/Makefile dependency. The compile error is completely
> disingenuous.
>
>   GEN     lib/oid_registry_data.c
> Compiling 49 OIDs
>   CC      lib/oid_registry.o
> gcc: error: lib/oid_registry.c: No such file or directory
> gcc: fatal error: no input files
> compilation terminated.
> make[3]: *** [lib/oid_registry.o] Error 4

I can't reproduce it either.  It's completely weird; nothing ever
removes lib/oid_registry.c, so either gcc is giving the wrong message or
it's a weird fs with a very odd race.

But your version is definitely more correct than the previous one, so...

Linus, please pull my 'more-fixes' branch:

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git more-fixes

Thanks,
Rusty.
