Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0H0MMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:12:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab0H0MMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:12:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87aao8gvbm.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
References: <87aao8gvbm.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me> <1282902149-12991-15-git-send-email-namhyung@gmail.com> <1282902149-12991-1-git-send-email-namhyung@gmail.com> <4072.1282906906@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 13:12:03 +0100
Message-ID: <5542.1282911123@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> wrote:

> > That description means nothing.  Commit
> > f76671df26ef06321480e702770f88f61272be29 is not upstream.
> 
> Hi,
> Thank you for noticing. My bad.

The problem with using a non-upstream commit ID like this is that it likely
won't be the same once that commit is committed by Linus.

> I just wanted to let you know it depends on that.

The patch being part of the series is probably sufficient, though a note of
the subject line of the previous patch would be useful.

> What is the proper way to handle this?

A summary of the changes being made is good:

	ptrace: Fix up the arguments arch_ptrace() in arch FRV

	Fix up the arguments to arch_ptrace() to take account of the fact that
	addr and data are now unsigned long rather than long as of a preceding
	patch in this series.

	Signed-off-by: ...

Note, however, that if the earlier patch breaks the compilation and then this
patch fixes it up, you should roll this patch into the earlier patch, and the
earlier patch is not complete without it.

Think what happens if patch 3/43 breaks an arch, and then patch 43/43, say,
mends that arch, and then bisection lands on patch 3 during its progress.  You
may end up having to 'git bisect skip' all the patches between 3 and 43 one at
a time.

David
