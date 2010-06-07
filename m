Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab0FGOsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 10:48:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab0FGOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 10:48:04 -0400
Date: Mon, 7 Jun 2010 07:41:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [kbuild regression, post-rc1] Remote installation over read-only
 NFS broken
In-Reply-To: <201006071110.26245.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1006070732170.3515@i5.linux-foundation.org>
References: <201006071110.26245.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Rafael J. Wysocki wrote:
> 
> Namely, I build kernels on a central machine and export the build directory
> along with the kernel sources over read-only NFS to test boxes.  Then, on the
> test boxes I run "make modules_install", copy the kernel to /boot, run mkinitrd
> and so on.  Now, after your commit above the "make modules_install" command on
> the test boxes doesn't work any more, because it tries to write to the build
> directory, which is mounted read-only.
> 
> Please fix or revert.

Ahh. It's broken for another reason too. Even if it's a writable 
filesystem, it means that there's a lot of files that get written by root 
(since you have to be root to do the install). Which is very 
uncomfortable, and we've tried very hard to avoid that.

So it _should_ be possible to do a build as a normal user, and then do the 
install as root, and afterwards

	find . -user root

should return the empty set (which in practice ends up being basically the 
same thing as Rafaels requirement that it work on a read-only build).

			Linus
