Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0ITOaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:30:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:46314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab0ITOap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:30:45 -0400
Date: Mon, 20 Sep 2010 16:30:40 +0200 (CEST)
From: Richard Guenther <rguenther@suse.de>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are
 reported clean in smaps
In-Reply-To: <201009192307.09309.knikanth@suse.de>
Message-ID: <alpine.LNX.2.00.1009201630200.8982@zhemvz.fhfr.qr>
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com> <20100915140911.GC4383@balbir.in.ibm.com> <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr> <201009192307.09309.knikanth@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010, Nikanth Karthikesan wrote:

> On Wednesday 15 September 2010 19:44:17 Richard Guenther wrote:
> > On Wed, 15 Sep 2010, Balbir Singh wrote:
> > > * Nikanth Karthikesan <knikanth@suse.de> [2010-09-15 12:01:11]:
> > > > How? Current smaps information without this patch provides incorrect
> > > > information. Just because a private dirty page became part of swap
> > > > cache, it shown as clean and backed by a file. If it is shown as clean
> > > > and backed by swap then it is fine.
> > >
> > > How is GDB using this information?
> > 
> > GDB counts the number of dirty and swapped pages in a private mapping and
> > based on that decides whether it needs to dump it to a core file or not.
> > If there are no dirty or swapped pages gdb assumes it can reconstruct
> > the mapping from the original backing file.  This way for example
> > shared libraries do not end up in the core file.
> > 
> 
> Well, may be /proc/pid/pagemap + /proc/kpageflags is enough for this! One can 
> get the pageflags using these interfaces. See Documentation/vm/pagemap.txt for 
> the explanation on how to do it. There is also a sample program that prints 
> page flags using this interface in Documentation/vm/page-types.c.
> 
> It is bad that /proc/pid/pagemap is never mentioned in 
> Documentation/filesystems/proc.txt. I will send a patch to rectify this.

Looks like /proc/kpageflags is root-only, so not a solution for gdb.

Richard.
