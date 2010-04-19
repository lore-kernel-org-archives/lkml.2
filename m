Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0DSUGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab0DSUGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:06:36 -0400
Date: Mon, 19 Apr 2010 22:06:23 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd: make Makefile rpm-friendly
In-Reply-To: <1271703972.10448.5.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1004192200570.4111@localhost.localdomain>
References: <20100419100058.6f1457dd.randy.dunlap@oracle.com> <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain> <1271703972.10448.5.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Apr 2010, Steven Rostedt wrote:

> On Mon, 2010-04-19 at 20:11 +0200, John Kacur wrote:
> > 
> > On Mon, 19 Apr 2010, Randy Dunlap wrote:
> > 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Update Makefile to support rpmbuild DESTDIR usage.
> > 
> > So, what would happen if you did
> > make DESTDIR=/usr/local install ?
> > 
> > I think you would get /usr/local/usr/local
> > So, I think I would NAK this patch.
> > 
> > I also don't believe there is anything magical about DESTDIR in a spec 
> > file. Essentially, prefix in this makefile is equivalent to DESTDIR, so 
> > you can replace DESTDIR with prefix in a spec template.
> >  
> 
> NAK is too strong. I was looking at what perf does, and it basically
> makes prefix and DESTDIR the same.
> 
> ifndef DESTDIR
> prefix = $(HOME)
> endif
> 
> We could do..
> 
> ifndef DESDIR
> prefix = /usr/local/bin
> endif
> 
> and then, if DESTDIR is not set, it would do the right thing.
> 

Yeah, the above is actually an unsatisfactory workaround.
see 7ae5f21361fea11f58c398701da635f778635d13

Another solution is to not copy obfuscated Makefiles when starting new
projects!
/me runs away
