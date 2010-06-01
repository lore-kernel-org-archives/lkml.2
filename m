Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0FATM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:12:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab0FATM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:12:26 -0400
Date: Tue, 1 Jun 2010 12:07:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] NOMMU: Add '[stack]' label to /proc/pid/maps output
In-Reply-To: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.1006011204270.8175@i5.linux-foundation.org>
References: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, David Howells wrote:
>
> From: Mike Frysinger <vapier@gentoo.org>
> 
> Add support to the NOMMU /proc/pid/maps file to show which mapping is the stack
> of the original thread after execve.  This is largely based on the MMU code.

Umm? The MMU code that we _reverted_?

It turns out to be totally useless, since people put stacks in various 
different places, and the values the kernel does see end up not even being 
the "real" stack top.

See commit 34441427aab4bdb3069a4ffcda69a99357abcb2e.

Just don't do it.

		Linus
