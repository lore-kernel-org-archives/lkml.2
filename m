Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab0HTMAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:00:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50909 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0HTMAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:00:16 -0400
Date: Fri, 20 Aug 2010 13:00:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] initramfs: remove sparse warnings
Message-ID: <20100820120001.GR31363@ZenIV.linux.org.uk>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
 <201008191638.23248.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008191638.23248.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 04:38:23PM +0200, Arnd Bergmann wrote:
> On Thursday 19 August 2010, Namhyung Kim wrote:
> > This patchset removes most of sparse warnings in init/initramfs.c.
> > Current implementation of initramfs relies on syscall service rountins heavily
> > so it requires many of arguments to be __user address space pointers but, in
> > most cases, were missing proper markups. This patchset tries to fix those at
> > a minimum change.
> 
> I'm skeptical about this, you are adding obviously incorrect annotations
> to the code to make something work that was written without the awareness
> for address spaces.
> 
> A better way would be to call path_lookup or kern_path to look up the
> path and pass that to a lower-level file I/O function.

No.  This code should *NOT* use the VFS guts, TYVM.  The whole fscking point
is that this puppy is a sequence of plain vanilla syscalls, ideally run
simply in userland thread.  We used to have a magical mystery shite in there
and it had been a huge PITA.
