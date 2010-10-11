Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0JKClI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 22:41:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0JKClE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 22:41:04 -0400
Date: Mon, 11 Oct 2010 03:41:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
Message-ID: <20101011024103.GH19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
 <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
 <20101010144952.GF19804@ZenIV.linux.org.uk>
 <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
 <20101010235256.GG19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010235256.GG19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 12:52:56AM +0100, Al Viro wrote:
> On Sun, Oct 10, 2010 at 10:18:03PM +0200, Geert Uytterhoeven wrote:
> > >> This is on aranym-0.9.9-1 from Ubuntu/amd64.
> > >
> > > stat -L /proc/2/exec, otherwise you'll hit lstat() instead of stat().
> > > And FWIW 0.9.10-1 squeeze/amd64 also triggers here...
> > 
> > Still, just "stat: cannot stat `proc/2/exe': No such file or directory" here...
> 
> Interesting...  Which gcc version is used?

Argh...  OK, going through aranym with debugger has exhonorated it.  My
apologies ;-/  It *is* gcc in sid.  Testcase:

extern int foo(int);
void *bar(int n)
{
        return (void *)foo(n);
}

and gcc -S -O2 turns that into
bar:
        link.w %fp,#0
        unlk %fp
        jra foo

Spot the obvious bug...  BTW, why on the Earth does debian-ports m68k tree
use gcc-4.3 with Cthulhu-scaring 700Kb gzipped patch and does *not* have
gcc-4.4?
