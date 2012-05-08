Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2EHNRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:17:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42645 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2EHNRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:17:36 -0400
Date: Tue, 8 May 2012 10:17:31 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] perf tools: Introduce perf_target__strerror()
Message-ID: <20120508131731.GH2485@infradead.org>
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
 <1336367344-28071-6-git-send-email-namhyung.kim@lge.com>
 <20120507172946.GC2485@infradead.org>
 <4FA809AD.7060209@gmail.com>
 <87r4uvcu4n.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4uvcu4n.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 08, 2012 at 10:57:12AM +0900, Namhyung Kim escreveu:
> On Mon, 07 May 2012 11:43:09 -0600, David Ahern wrote:
> > On 5/7/12 11:29 AM, Arnaldo Carvalho de Melo wrote:
> >> So what is missing in this case is that top starts with system_wide set,
> >> not from the command line.
> >>
> > Seems like we should avoid the propagation of the errnos beyond the
> > depths of the library part. For perf-top why not default to nothing
> > set and if the user does not request one, set system wide. i.e,
> > following Patch 6 in this set do:
> >
> > if (perf_target__none(&top.target)
> >     top.target.system_wide = true;
> >
> 
> Thanks for catching this (and sorry for not testing thoroughly).
> 
> Yes, this would make more sense if it goes to the patch 1. Now I see
> that Arnaldo fixed it on patch 1 but forgot to update on patch 6 :).

Oh, I see, adding a follow up patch using the __none method, my case
wasn't checking cpu_list, so this is not just a simple helper
replacement but a bug fix.

- Arnaldo
