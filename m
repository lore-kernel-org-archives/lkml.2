Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab1FURXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:23:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46449 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab1FURXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QvIIvAegAWAZo3QYd0Lafkmb6d192ayX7vovcyhKJDtPRYtUldRYo1Dim0G2k/lh+C
         6C68asl4vH+Cp2FHzmtftHF5eQFcAc63JxE0HTtR0z0nc1Z5Bs03D2qNZXIVYPZexXqM
         f14CBxedRqjkBJj05qDjnV3IcpCH+g0n+QPOs=
Date: Tue, 21 Jun 2011 21:23:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110621172319.GE21641@sun>
References: <4DB989B5.1030703@openvz.org>
 <20110621152301.GA5155@redhat.com>
 <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
 <1308671933.26237.183.camel@twins>
 <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
 <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
 <20110621164820.GC21641@sun>
 <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 07:10:05PM +0200, Stephane Eranian wrote:
...
> >
> >  The key here is that we use that named non-sleeping ticks (as oprofile
> > did) for nmi-watchdog and it allows us to free "cpu-cycles" counter for
> > user needs. Of course we pick up one counter for this but it doesn't intersect
> > with "cpu-cycles" counter (because counters are grouped and can count only
> > specified events in each group). Stepane, should I post more details?
> >
> Ok, so you're using a different PMU event for the watchdog. But then, in this
> case why not simply change kernel/watchdog.c to hardcode something specific
> for P4, i.e, change the wd_hw_attr.config/type fields to match the
> event you want.

  It doesn't change things much. Of course I can put some specifics into
.config but where is the guarantee some new generic event would not ever
intersect with it. I know (for example) we could reserve -1ULL for this
event but again where is the guarantee that it will never ever be used
system wide in future for some different event?

So I need some event-id in which I may be sure it will never be
used for different purpose.

> You could create a arch specific callback to setup config/type.
> 
> I don't think it makes sense to expose yet another generic PMU event, especially
> given the name you gave to it and what it actually does. People might wonder
> what good is that for?

	Cyrill
