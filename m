Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0EYPa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:30:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0EYPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:30:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Tue, 25 May 2010 17:30:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005251703.11613.arnd@arndb.de> <4BFBE8FF.6080208@tilera.com>
In-Reply-To: <4BFBE8FF.6080208@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251730.18830.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+sYDVBZkCsyy2gpjbrdobqYT1y5Mb6qDtfhIz
 vaPD45D5yrs+sCnPCa+syvNP8f5YmrernlSW9jRs0QBHzHNB8m
 Cfi5OUF7h0UnudyVon91w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Chris Metcalf wrote:
> >  The idea was to only have them around as a transitional helper for
> > new architectures while getting merged, but nothing should ever
> > use these in production.
> >   
> 
> Perhaps the best strategy for Tile for now is to enable the transitional
> helpers, and then when glibc no longer requires any of those syscalls,
> we can remove them from the kernel.  If this happens in the relatively
> short term (e.g. before our 3.0 release later this year) all the better,
> but for now we can separate this into a first change that preserves most
> of the compatibility syscalls, and work towards remove them in a later
> release.

I don't like the idea of adding syscalls first and then disabling them
again. We tried that on score and now we're stuck with the wrong syscall
table there because they never got removed.

Instead, I'd suggest you do the minimal syscall table for upstream and
just carry a private patch to enable the other syscalls until you get
a working glibc/eglibc/uclibc with the official kernel.

	Arnd
