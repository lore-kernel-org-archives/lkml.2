Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1AYRpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:45:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1AYRpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:45:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
X-Fcc: ~/Mail/linus
Cc: linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
In-Reply-To: Arnd Bergmann's message of  Tuesday, 25 January 2011 15:29:24 +0100 <201101251529.24779.arnd@arndb.de>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
	<201101251529.24779.arnd@arndb.de>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20110125174515.C1DC2183C19@magilla.sf.frob.com>
Date: Tue, 25 Jan 2011 09:45:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My feeling is that it should be in glibc: as Mike mentioned, we don't normally
> change the behavior of existing system calls unless they are obviously
> broken to start with. If we want to keep fchmodat getting the implicit
> "." directory, and at the same time keep fchmod returning an error, the fchmod
> wrapper around fchmodat is the only place that can enforce this.

My point was that it's quite arguable that the *at syscall interfaces were
broken to begin with.  I've never seen anything suggesting their intent was
other than to permit relative pathnames, and the empty string has never
been a valid relative pathname.  To fit the POSIX requirements as I read
them, the *at functions must refuse to resolve the empty string.  So if the
kernel does not change and my interpretation of POSIX stands, then libc
must wrap all the *at syscalls with a function that checks for the empty
string and fails with ENOENT as a special case.

I don't have any strong opinion about this subject, but it makes the most
sense to me for the kernel's behavior to change.  I know of no reason to
think that the current treatment of the empty string was ever intended at
the creation of the *at interfaces.


Thanks,
Roland
