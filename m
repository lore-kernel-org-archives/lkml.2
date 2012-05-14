Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2ENHFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:05:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54851 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2ENHFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:05:12 -0400
Date: Mon, 14 May 2012 09:05:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
Message-ID: <20120514070507.GB27980@gmail.com>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
 <20120512212531.GC20057@infradead.org>
 <CA+55aFzGAokE5htNFhkoRxT5bK1_5=uofkC5xZipTtiawSh_hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzGAokE5htNFhkoRxT5bK1_5=uofkC5xZipTtiawSh_hA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, May 12, 2012 at 2:25 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> >
> > Didn't notice it, but then I'm not updating the kernel that frequently,
> > will check on this Sandy Bridge nobo (i7-2920XM).
> 
> I think SNB has problems with PEBS and cycles anyway. I have a 
> westmere machine that I use for profiling for that reason.

I have a pre-westmere Nehalem that I use most for perf testing - 
that one appears to be working well both with default cycles and 
with cycles:pp. Will test on a Westmere.

btw., Arnaldo, could we make cycles:pp the default event on perf 
record and perf top? We have the new AMD IBS code in perf/core 
queued up for v3.5, which is roughly equivalent to cycles:p on 
Intel CPUs, so if we standardize on cycles:pp we'll get improved 
skidless (and on Intel pre-SB CPUs, precise) profiling output by 
default.

While at it I'd also suggest increasing the default sampling 
frequency, from 1000 Hz per CPU to at least 4Khz auto-freq or so 
- this should work well all across the board I think. CPUs are 
getting faster and command/app run times are getting shorter, 
1Khz is a bit low IMO.

Thanks,

	Ingo
