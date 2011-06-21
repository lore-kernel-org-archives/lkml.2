Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1FUQs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:48:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1FUQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JWgMM5brhGikmbfl41Erivxt5iAdZnSwmAej+OcqV3NtsHSaXzyxM3HY788Pa50Mux
         Z19ZxatAky8nTE95AMH4EHHqaf8EiyxCSxbxbXS4yEFEUlCucRzuxeSy2SF9SBC42W8R
         Ufeoo3HXAaJ3bhpw8ZmQCADzAfFqqWoi60Pn8=
Date: Tue, 21 Jun 2011 20:48:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110621164820.GC21641@sun>
References: <4DB989B5.1030703@openvz.org>
 <20110621152301.GA5155@redhat.com>
 <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
 <1308671933.26237.183.camel@twins>
 <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
 <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 06:20:56PM +0200, Stephane Eranian wrote:
> Cyrill,
> [repost because of MIME crap]

I saw first as well, sorry for delay, my isp is broken today :/

> 
> I admit I don't quite understand how this patch works around
> the limitation. In the end you are still going to program some cycle
> event into a P4 PMU register. So how it is going to free more counters
> for regular users?
> 
> 

  The key here is that we use that named non-sleeping ticks (as oprofile
did) for nmi-watchdog and it allows us to free "cpu-cycles" counter for
user needs. Of course we pick up one counter for this but it doesn't intersect
with "cpu-cycles" counter (because counters are grouped and can count only
specified events in each group). Stepane, should I post more details?

	Cyrill
