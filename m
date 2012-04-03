Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2DCSSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:18:09 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50949 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2DCSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:18:04 -0400
Date: Tue, 3 Apr 2012 11:16:31 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
Message-ID: <20120403181631.GD32299@count0.beaverton.ibm.com>
References: <20120331091049.19373.28994.stgit@zurg>
 <20120331092929.19920.54540.stgit@zurg>
 <20120331201324.GA17565@redhat.com>
 <20120402230423.GB32299@count0.beaverton.ibm.com>
 <4F7A863C.5020407@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7A863C.5020407@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040318-7408-0000-0000-000003F17F54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 09:10:20AM +0400, Konstantin Khlebnikov wrote:
> Matt Helsley wrote:
> >On Sat, Mar 31, 2012 at 10:13:24PM +0200, Oleg Nesterov wrote:
> >>On 03/31, Konstantin Khlebnikov wrote:
> >>>
> >>>comment from v2.6.25-6245-g925d1c4 ("procfs task exe symlink"),
> >>>where all this stuff was introduced:
> >>>
> >>>>...
> >>>>This avoids pinning the mounted filesystem.
> >>>
> >>>So, this logic is hooked into every file mmap/unmmap and vma split/merge just to
> >>>fix some hypothetical pinning fs from umounting by mm which already unmapped all
> >>>its executable files, but still alive. Does anyone know any real world example?
> >>
> >>This is the question to Matt.
> >
> >This is where I got the scenario:
> >
> >https://lkml.org/lkml/2007/7/12/398
> 
> Cyrill Gogcunov's patch "c/r: prctl: add ability to set new mm_struct::exe_file"
> gives userspace ability to unpin vfsmount explicitly.

Doesn't that break the semantics of the kernel ABI?

Cheers,
	-Matt Helsley

