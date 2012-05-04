Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2EDSIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:08:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab2EDSIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:08:14 -0400
Date: Fri, 4 May 2012 20:08:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] perf, tool: Fix endian issues
Message-ID: <20120504180800.GD2995@m.brq.redhat.com>
References: <1336151493-8328-1-git-send-email-jolsa@redhat.com>
 <4FA41481.7000704@gmail.com>
 <20120504175940.GC29365@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504175940.GC29365@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 02:59:40PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 04, 2012 at 11:40:17AM -0600, David Ahern escreveu:
> > On 5/4/12 11:11 AM, Jiri Olsa wrote:
> > >hi,
> > >sending fixies to properly handle perf.data endians.
> > >
> > >v2 changes:
> > >   - added patches 3 and 4 to handle sample_id_all header endianity
> > >
> > >Attached patches:
> > >   1/4 perf, tool: Handle different endians properly during symbol load
> > >   2/4 perf, tool: Carry perf_event_attr bitfield throught different endians
> > >   3/4 perf, tool: Handle endianity swap on sample_id_all header data
> > >   4/4 perf, tool: Fix 32 bit values endianity swap for sample_id_all header
> > 
> > Have you tested these patches by collecting data on PPC (or other
> > big endian) and analyzing on Intel x86 and vice versa?
> 
> I think so, but indeed it is good practice to show the sequence made to
> test the changes, with sample, short command output before and after.
> 
> - Arnaldo

yep, I should have mentioned that..

I did following testing with x86_64 and ppc64:

1. perf record -a -- sleep 10
2. perf report > report.origin
3. perf archive perf.data
4. copy the perf.data.tar.bz2 to a target system
5. tar xjvf perf.data.tar.bz2 -C ~/.debug
6. perf report > report.target
7. diff -u report.origin report.target

the diff should produce no output

hm, I did jsut x86_64 record and ppc64 report.. will do also
the other way around and resend with updated changelog 

thanks,
jirka
