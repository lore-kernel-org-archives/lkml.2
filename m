Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2EJQbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab2EJQax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:30:53 -0400
Date: Thu, 10 May 2012 18:30:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Caspar Zhang <czhang@redhat.com>
Subject: Re: [PATCHv3 0/5] perf, tool: Fix endian issues
Message-ID: <20120510163033.GA10395@m.brq.redhat.com>
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
 <4FA897BD.4000304@gmail.com>
 <20120510103825.GA4283@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510103825.GA4283@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:38:25PM +0200, Jiri Olsa wrote:
> On Mon, May 07, 2012 at 09:49:17PM -0600, David Ahern wrote:
> > On 5/7/12 5:29 AM, Jiri Olsa wrote:
> > >Tested by running following usecase:
> > >   - origin system:
> > >     # perf record -a -- sleep 10 (any perf record will do)
> > >     # perf report>  report.origin
> > >     # perf archive perf.data
> > >
> > >   - copy the perf.data, report.origin and perf.data.tar.bz2
> > >     to a target system and run:
> > >     # tar xjvf perf.data.tar.bz2 -C ~/.debug
> > >     # perf report>  report.target
> > >     # diff -u report.origin report.target
> > >
> > >   - the diff should produce no output
> > >     (besides some white space stuff and possibly different
> > >      date/TZ output)
> > >
> > >Tested by above usecase cross following architectures:
> > >   i386, x86_64, s390x, ppc64
> > 
> > Short answer: Now that I have perf compiling in a 32-bit PPC VM,
> > applied the patchset and rebuilding -- it does not work for me.
> 
> hi,
> Could I ask what VM did you use? My qemu setup does not seem
> to offer this one.
> 
> so it's [32 bits big endian] into [64 bits small endian]
> 
> I tested i386 to ppc64. The endianity is the other way round,
> I wonder whats wrong with your tested direction.
> 
> hunting testing machine ;)

reproduced ;) working on fix

jirka
