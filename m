Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab2BHVYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:24:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab2BHVYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:24:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F32A98F.7030400@zytor.com>
References: <4F32A98F.7030400@zytor.com> <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com> <8328.1328703626@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
Date: Wed, 08 Feb 2012 21:24:22 +0000
Message-ID: <16325.1328736262@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> Anyway, select() paraphernalia goes in <sys/time.h> (as opposed to
> <time.h>), poll() paraphernalia goes in <sys/poll.h>, and the linux/*
> files mimics that.

That doesn't seem to be so - at least not for my copy of glibc:

/usr/include/sys/select.h:/* fd_set for select and pselect.  */
/usr/include/sys/select.h:  } fd_set;
/usr/include/sys/select.h:#define       FD_ISSET(fd, fdsetp)    __FD_ISSET (fd, fdsetp)

Besides, this is inside the kernel.  The I/O polling architecture definitions
(which includes select) ought to be in one place there, not spread out all
over the place.

David
