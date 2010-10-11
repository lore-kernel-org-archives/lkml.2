Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0JKFYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 01:24:47 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:40967 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0JKFYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 01:24:46 -0400
X-Greylist: delayed 2871 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 01:24:45 EDT
Date: Sun, 10 Oct 2010 21:36:32 -0700
From: Brad Boyer <flar@allandria.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent kernels
Message-ID: <20101011043632.GA2566@cynthia.pants.nu>
References: <20101007174948.GT19804@ZenIV.linux.org.uk> <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com> <20101010144952.GF19804@ZenIV.linux.org.uk> <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com> <20101010235256.GG19804@ZenIV.linux.org.uk> <20101011024103.GH19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011024103.GH19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 03:41:03AM +0100, Al Viro wrote:
> Argh...  OK, going through aranym with debugger has exhonorated it.  My
> apologies ;-/  It *is* gcc in sid.  Testcase:
> 
> extern int foo(int);
> void *bar(int n)
> {
>         return (void *)foo(n);
> }
> 
> and gcc -S -O2 turns that into
> bar:
>         link.w %fp,#0
>         unlk %fp
>         jra foo
> 

I presume the bug is that foo put the return value in %d0 while bar
should have its return value in %a0. This function isn't eligible
for the optimization being used due to this need to move the result
into a different register.

> Spot the obvious bug...  BTW, why on the Earth does debian-ports m68k tree
> use gcc-4.3 with Cthulhu-scaring 700Kb gzipped patch and does *not* have
> gcc-4.4?

I believe that gcc-4.4 for m68k is being held up by the TLS support patches.
While I haven't been personally involved to any great degree, I got the
impression that the work is pretty much done other than getting it included.

	Brad Boyer
	flar@allandria.com

