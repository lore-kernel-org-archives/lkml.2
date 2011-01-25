Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1AYSVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:21:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1AYSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:21:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 19:21:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.5.1; x86_64; ; )
Cc: linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <201101251529.24779.arnd@arndb.de> <20110125174515.C1DC2183C19@magilla.sf.frob.com>
In-Reply-To: <20110125174515.C1DC2183C19@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251921.15184.arnd@arndb.de>
X-Provags-ID: V02:K0:QMmDK7AV3OOetT+gsVDre4UKPKnSZ0+0/GZjkwNLSwC
 +HdZKiI+4/gOXe1wYZjhNIcG9VIoMuPoeRlAhhZ9LKfYU8308A
 ila/Bj5o4iIj5ufC4qFZyvtACN6EucgjCnshXu5WQ9zrrEVMYV
 HPgr7bDXdHyL0m6GRh1IAUVH5pW/Lu4sY6u02Zdju3YJMa32/q
 v1o/SOuGisE8yRPXEw7mQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
>  I know of no reason to
> think that the current treatment of the empty string was ever intended at
> the creation of the *at interfaces.

I always assumed that this was done so that the *at syscalls can replace
both the ones that take a file descriptor (e.g. fstat) and the ones that
take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD case,
although not documented in the man pages.

Treating the empty string special for AT_FDCWD is rather pointless, but
at least consistent.

	Arnd
