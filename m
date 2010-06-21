Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0FUROX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:14:23 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:51998 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0FUROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:14:22 -0400
Date: Mon, 21 Jun 2010 12:13:47 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Manfred Spraul <manfred@colorfullife.com>
cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
In-Reply-To: <4C1F98C3.6090003@colorfullife.com>
Message-ID: <alpine.DEB.2.00.1006211212500.7407@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <alpine.DEB.2.00.1006180955141.11575@router.home> <4C1CD791.101@colorfullife.com> <alpine.DEB.2.00.1006210927310.4513@router.home> <4C1F98C3.6090003@colorfullife.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Manfred Spraul wrote:

> On 06/21/2010 04:31 PM, Christoph Lameter wrote:
> > > - If I run make -j5 bzImage, then no semaphore arrays are used.
> > > Could you try to figure out which executable is doing the 'semop()' call?
> > >
> > Looks like this was ld
> >
> >
> Ok, that doesn't help:
> $ grep semop -r binutils-2.20.51.0.2/
> <nothing>
>
> My guess: On your system, something is preloaded with LD_PRELOAD, and that
> library hangs.
> I have no idea which library, and I don't know if it's a library bug or a
> kernel bug.

No need to guess. The kernel build is run under fakeroot as evident from
the command line I gave you. Fakeroot works fine with 2.6.34.


