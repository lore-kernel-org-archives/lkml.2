Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1FURCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:02:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54924 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1FURCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PuFkCib6ajnfOD9Zyrcjrn9CsDPi0dsMk3kem1oBCAgjWSBuCTJ31Gol0qH9t2yj0V
         B6chKNr9ohXpsQWiEc9/5OdniApN4UcgCVuS4BlEjYA0QihQLKdK1TQiQAC/nSRDJ5TK
         ojOgrDALiNAibWijfCHL+HJGfwsK/xrUgWFcw=
Date: Tue, 21 Jun 2011 21:02:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110621170229.GD21641@sun>
References: <4DB989B5.1030703@openvz.org>
 <20110621152301.GA5155@redhat.com>
 <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
 <1308671933.26237.183.camel@twins>
 <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
 <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
 <20110621164820.GC21641@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621164820.GC21641@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 08:48:20PM +0400, Cyrill Gorcunov wrote:
...
> 
>   The key here is that we use that named non-sleeping ticks (as oprofile
> did) for nmi-watchdog and it allows us to free "cpu-cycles" counter for
> user needs. Of course we pick up one counter for this but it doesn't intersect
> with "cpu-cycles" counter (because counters are grouped and can count only
> specified events in each group). Stepane, should I post more details?
> 
> 	Cyrill

  Stephane, I think I have a shorter explanation -- the counter is still borrowed
(there is no magic ;) but this counter is less loaded than anything else (in
terms of restrictions) so since CPU cycles is a way more popular now it's allowed
to count them simultaneously with nmi-watchdog, but again  -- this means
another set of events can't work and if (for some reason) user needs this counter
he has to disable nmi-watchdog.

	Cyrill
