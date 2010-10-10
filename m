Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0JJOtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:49:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52498 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0JJOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:49:54 -0400
Date: Sun, 10 Oct 2010 15:49:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
Message-ID: <20101010144952.GF19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
 <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 11:47:20AM +0200, Geert Uytterhoeven wrote:
> > The cheapest way to reproduce is to boot with init=/bin/sh, then
> > mount /proc and have stat("/proc/2/exe", &st) called; if stat()
> > returns 0, we are fscked. ??The critical part is between return
> > from proc_exe_link() (we'll leave it via if (!mm) return -ENOENT;)
> > to return from __do_follow_link() -> do_follow_link() -> link_path_walk().
> 
> I booted 2.6.36-rc7-atari-00360-g0dd2e6a (my current private test kernel) with
> init=/bin/sh, mounted /proc, and tried
> 
>     for i in $(seq 1000); do stat /proc/2/exe; done
> 
> a few times, but I didn't see any ida_remove messages.
> It cannot read the /proc/2/exe symlink, though.
> 
> This is on aranym-0.9.9-1 from Ubuntu/amd64.

stat -L /proc/2/exec, otherwise you'll hit lstat() instead of stat().
And FWIW 0.9.10-1 squeeze/amd64 also triggers here...
