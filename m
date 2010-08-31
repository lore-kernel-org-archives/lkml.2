Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0HaVfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:35:43 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:24614 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750721Ab0HaVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:35:42 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6mq_l4QVM1naimlRuDGrJ9lokEyt.3k.YbgQ0LCaSbNS8k8
 h7JKlr1JhFlXuxEsrAUTSyOf1GL2B_pfj3YWLbzxW8B9ZTymfEtgzMw9BeP3
 DLHuKFUHziAV9NQ5EldUlXbr1SnePxyQC1fGDVm1kbF3A3sQPEughNVHv5JA
 1nU0euXuzcXJKAP8DD4xXmg3G0UUgVtlm7zL1kCtEuAq96_g2Gihv_0rYqJm
 K
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 Aug 2010 16:35:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
In-Reply-To: <1283290106.2198.26.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1008311635100.867@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>  <1281374816-904-4-git-send-email-ngupta@vflare.org>  <alpine.DEB.2.00.1008301114460.10316@router.home>  <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>
 <1283290106.2198.26.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Eric Dumazet wrote:

> > Yes, this_cpu_add() seems sufficient. I can't recall why I used u64_stats_*
> > but if it's not required for atomic access to 64-bit then why was it added to
> > the mainline in the first place?
>
> Because we wanted to have fast 64bit counters, even on 32bit arches, and
> this has litle to do with 'atomic' on one entity, but a group of
> counters. (check drivers/net/loopback.c, lines 91-94). No lock prefix
> used in fast path.
>
> We also wanted readers to read correct values, not a value being changed
> by a writer, with inconsistent 32bit halves. SNMP applications want
> monotonically increasing counters.
>
> this_cpu_add()/this_cpu_read() doesnt fit.
>
> Even for single counter, this_cpu_read(64bit) is not using an RMW
> (cmpxchg8) instruction, so you can get very strange results when low
> order 32bit wraps.

How about fixing it so that everyone benefits?

