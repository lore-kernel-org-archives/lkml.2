Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2DBXFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:05:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47020 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab2DBXFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:05:12 -0400
Date: Mon, 2 Apr 2012 16:04:23 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org, oprofile-list@lists.sf.net,
        Matt Helsley <matthltc@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
Message-ID: <20120402230423.GB32299@count0.beaverton.ibm.com>
References: <20120331091049.19373.28994.stgit@zurg>
 <20120331092929.19920.54540.stgit@zurg>
 <20120331201324.GA17565@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331201324.GA17565@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040223-1976-0000-0000-00000C018637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 10:13:24PM +0200, Oleg Nesterov wrote:
> On 03/31, Konstantin Khlebnikov wrote:
> >
> > comment from v2.6.25-6245-g925d1c4 ("procfs task exe symlink"),
> > where all this stuff was introduced:
> >
> > > ...
> > > This avoids pinning the mounted filesystem.
> >
> > So, this logic is hooked into every file mmap/unmmap and vma split/merge just to
> > fix some hypothetical pinning fs from umounting by mm which already unmapped all
> > its executable files, but still alive. Does anyone know any real world example?
> 
> This is the question to Matt.

This is where I got the scenario:

https://lkml.org/lkml/2007/7/12/398

Cheers,
	-Matt Helsley

PS: I seem to keep coming back to this so I hope folks don't mind if I leave
some more references to make (re)searching this topic easier:

Thread with Cyrill Gorcunov discussing c/r of symlink:
https://lkml.org/lkml/2012/3/16/448

Thread with Oleg Nesterov re: cleanups:
https://lkml.org/lkml/2012/3/5/240

Thread with Alexey Dobriyan re: cleanups:
https://lkml.org/lkml/2009/6/4/625

mainline commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07
Date:   Tue Apr 29 01:01:36 2008 -0700

	procfs task exe symlink

