Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1BJSTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:19:11 -0500
Received: from mailhost.tue.nl ([131.155.2.19]:50876 "EHLO mailhost.tue.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab1BJSTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:19:08 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 13:19:08 EST
Date: Thu, 10 Feb 2011 19:12:21 +0100
From: Andries Brouwer <aebr@win.tue.nl>
To: Roland McGrath <roland@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com,
        Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Message-ID: <20110210181221.GA19413@win.tue.nl>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
 <201101251529.24779.arnd@arndb.de>
 <20110125174515.C1DC2183C19@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125174515.C1DC2183C19@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 09:45:15AM -0800, Roland McGrath wrote:

> the empty string has never been a valid relative pathname.

Hmm. I definitely recall otherwise.

The old Unix definition is that the empty string stands for "."
so that 'ls ""' means the same as 'ls .'
and 'ls /tmp/""' the same as 'ls /tmp/.'.

Let me try.

On a recent Linux system:

% ls -l ""
ls: cannot access : No such file or directory

On an old Unix system:

# ls -l ""
drwxr-xr-x  2 bin      1040 Jan  1  1970 bin
drwxr-xr-x  2 bin       352 Jan  1  1970 dev
drwxr-xr-x  2 bin       304 Aug 20 12:39 etc
...

Andries
