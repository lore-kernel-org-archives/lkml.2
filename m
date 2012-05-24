Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab2EXTtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab2EXTtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:49:10 -0400
Date: Thu, 24 May 2012 21:48:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf, tool: Fix endianity trick for adds_features
 bitmask
Message-ID: <20120524194834.GC2346@m.redhat.com>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
 <1337151548-2396-7-git-send-email-jolsa@redhat.com>
 <4FBB1839.6000606@gmail.com>
 <20120522084153.GC2901@m.brq.redhat.com>
 <4FBBB539.5010805@gmail.com>
 <20120523175912.GA9213@m.brq.redhat.com>
 <4FBE547A.5020900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE547A.5020900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:32:10AM -0600, David Ahern wrote:
> On 5/23/12 11:59 AM, Jiri Olsa wrote:
> >On Tue, May 22, 2012 at 09:48:09AM -0600, David Ahern wrote:
> >>On 5/22/12 2:41 AM, Jiri Olsa wrote:
> >>
> >>>hm, any special details for the record? because I'm sure I tested this way..
> >>>
> >>>I'll retest, thanks
> >>>jirka
> >>
> >>
> >>The attached fixes it.
> >
> >>commit 1353676ca6551a0165df030784ada20ebea73f73
> >>Author: David Ahern<dsahern@gmail.com>
> >>Date:   Tue May 22 09:40:17 2012 -0600
> >>
> >>     perf, tool: Fix endianity swapping for adds_features bitmask
> >>
> >>     Based on Jiri's latest attempt:
> >>     https://lkml.org/lkml/2012/5/16/61
> >>
> >>     Basically, adds_features should be byte swapped assuming unsigned
> >>     longs are either 8-bytes (u64) or 4-bytes (u32).
> >>
> >>     Fixes 32-bit ppc dumping 64-bit x86 feature data:
> >>      ========
> >>      captured on: Sun May 20 19:23:23 2012
> >>      hostname : nxos-vdc-dev3
> >>      os release : 3.4.0-rc7+
> >>      perf version : 3.4.rc4.137.g978da3
> >>      arch : x86_64
> >>      nrcpus online : 16
> >>      nrcpus avail : 16
> >>      cpudesc : Intel(R) Xeon(R) CPU E5540 @ 2.53GHz
> >>      cpuid : GenuineIntel,6,26,5
> >>      total memory : 24680324 kB
> >>     ...
> >>
> >>     Verified 64-bit x86 can still dump feature data for 32-bit ppc.
> >>
> >>     Signed-off-by: David Ahern<dsahern@gmail.com>
> >
> >I got the header properly displayed with this patch, but I'm getting
> >following diffs in the perf report output (ppc32 vs x86_64):
> >(after moving origin perf archive build-id cache to target system)
> >
> >-     0.00%            perf  [ext4]               [k] 0x0005b318
> >+     0.00%            perf  [ext4]               [k] .cleanup_module
> >
> >-     0.00%             yes  [kernel.kallsyms]    [k] .sys_write
> >+     0.00%             yes  [kernel.kallsyms]    [k] .SyS_write
> >
> >  ^^^ this one is particularly disturbing ;)
> >
> >I guess it's unrelated to the header stuff which your patch fixes
> >properly I think, but I got small conflict rebasing this to current tip
> >
> >Reviewed-by: Jiri Olsa<jolsa@redhat.com>
> 
> That is odd... and if you are getting that much you are ahead of me.
> When I analyze an x86_64 file on ppc32 all symbols show as
> kernel.kallsyms dso.

I made some load and collected wide system data

> 
> The patch applies cleanly for me on latest acme/core:
> $ patch -p1 < perf-swap-features.patch
> patching file tools/perf/util/header.c
> patching file tools/perf/util/include/linux/bitops.h
> patching file tools/perf/util/session.c
> patching file tools/perf/util/session.h

hm, I had some troubles aplying this to current tip, maybe it's ok now

I'll deal with this issue and send the rest of the patches (updated with
your comments) I have together with the new fix.

jirka
