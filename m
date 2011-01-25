Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1AYUFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:05:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1AYUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:05:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 21:04:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.5.1; x86_64; ; )
Cc: linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <201101251921.15184.arnd@arndb.de> <20110125183437.7C6C2180999@magilla.sf.frob.com>
In-Reply-To: <20110125183437.7C6C2180999@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101252104.58011.arnd@arndb.de>
X-Provags-ID: V02:K0:eJsXufczsqBYZ2CdStmXoFN/zVHO1SEcB88lBcJZEyt
 1ucTlNs2IAVyP2ko0PBblKq8dusmaxgQnqJioYlwLRDuKhkp0f
 chJDszE1Dt8UeCEAuxvZ0aR5q7o2dfDJWmxVjJa9WOLrLuGWvP
 uHjWwaDBj6cfpPd4UO3qVb269zIrk9GVQELYAHrXLrNo4L3l4n
 SQ9liwPBE4WIpykHQdypg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 January 2011 19:34:37 Roland McGrath wrote:
> I don't think this was part of the original intent when the calls were
> added, but I suppose it makes sense.

More importantly, even if it was never meant this way, anyone could have
assumed that it was and started using the system call in this way.

> > Treating the empty string special for AT_FDCWD is rather pointless, but
> > at least consistent.
> 
> I agree about the consistency point.  However, one could also call it
> consistent if the empty string fails to resolve when operating on either a
> directory file descriptor or AT_FDCWD but works on a non-directory file
> descriptor. 

Yes.

> POSIX does not mandate that *at calls fail with ENOTDIR when
> passed a non-directory file descriptor (it's a "may fail" error, not a
> "shall fail" error).  So that behavior would be consistent both with the
> POSIX requirements as I read them, and with the desire you mentioned to let
> the fblahat system call serve to implement fblah as well as blah.  Then
> libc would not have to wrap the *at calls with any special check to conform
> to POSIX.

Makes sense.

	Arnd
