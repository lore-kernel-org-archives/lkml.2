Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1AXVFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1AXVFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:05:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: linasvepstas@gmail.com
X-Fcc: ~/Mail/linus
Cc: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
In-Reply-To: Linas Vepstas's message of  Monday, 24 January 2011 13:57:56 -0600 <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
X-Windows: sometimes you fill a vacuum and it still sucks.
Message-Id: <20110124210514.AB18918020B@magilla.sf.frob.com>
Date: Mon, 24 Jan 2011 13:05:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX says "A null pathname shall not be successfully resolved."  This
applies to relative pathnames too, and a file name argument to an *at
function using AT_FDCWD is a relative pathname.  So I think there is no
situation at all in which the empty string should resolve to anything.
It's generally in the domain of the kernel to enforce these kinds of rules,
so I think that having the kernel fail with ENOENT for all empty-string
cases is the right thing to do.

Thanks,
Roland
