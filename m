Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2EVImO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2EVImL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:42:11 -0400
Date: Tue, 22 May 2012 10:41:53 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf, tool: Fix endianity trick for adds_features
 bitmask
Message-ID: <20120522084153.GC2901@m.brq.redhat.com>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
 <1337151548-2396-7-git-send-email-jolsa@redhat.com>
 <4FBB1839.6000606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB1839.6000606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:38:17PM -0600, David Ahern wrote:
> On 5/16/12 12:59 AM, Jiri Olsa wrote:
> >Addons bitmask is stored as array of unsigned long values. The size
> >of the unsigned long is same as pointer size for architecture, so it
> >could differ for each architecture.
> >
> >To handle the endianity for adds_features bitmask, we first swap the
> >bitmaks as u64 values and check for HEADER_HOSTNAME bit. If not set we
> >want to unswap the u64 values and swap the adds_features as u32 values.
> >
> >This is currently buggy, since we swap just first 32bits of each u64
> >value. Adding swap of the next 32 bits as well.  Also adding&  using
> >BITS_TO_U64 instead of BITS_TO_LONGS as counter max due to the different
> >size of unsigned longs per architecture.
> >
> >Note, running following to test perf endianity handling:
> >test 1)
> >   - origin system:
> >     # perf record -a -- sleep 10 (any perf record will do)
> >     # perf report>  report.origin
> >     # perf archive perf.data
> >
> >   - copy the perf.data, report.origin and perf.data.tar.bz2
> >     to a target system and run:
> >     # tar xjvf perf.data.tar.bz2 -C ~/.debug
> >     # perf report>  report.target
> >     # diff -u report.origin report.target
> >
> >   - the diff should produce no output
> >     (besides some white space stuff and possibly different
> >      date/TZ output)
> >
> >test 2)
> >   - origin system:
> >     # perf record -ag -fo /tmp/perf.data -- sleep 1
> >   - mount origin system root to the target system on /mnt/origin
> >   - target system:
> >     # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
> >      --kallsyms /mnt/origin/proc/kallsyms
> >   - complete perf.data header is displayed
> >
> >Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> 
> 32-bit ppc reading 64-bit x86 still does not work:
> 
> # ========
> # captured on: Sun May 20 19:23:23 2012
> # ========
> #
> 
> Why not? It suggests there is still a bug in the processing of the
> adds_feature bitmap.

hm, any special details for the record? because I'm sure I tested this way..

I'll retest, thanks
jirka
