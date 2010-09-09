Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0IIHs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:48:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0IIHsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:48:21 -0400
Date: Thu, 9 Sep 2010 09:48:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cliff Wickman <cpw@sgi.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: copy_oldmem_page using cached addressing
Message-ID: <20100909074813.GA8355@elte.hu>
References: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
 <m1eid4gi0g.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eid4gi0g.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0954]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Cliff Wickman <cpw@sgi.com> writes:
> 
> > From: Cliff Wickman <cpw@sgi.com>
> >
> > The copy of /proc/vmcore to a user buffer proceeds much faster
> > if the kernel addresses memory as cached.
> >
> > With this patch we have seen an increase in transfer rate from less than
> > 15MB/s to 80-460MB/s, depending on size of the transfer.  This makes
> > a big difference in time needed to save a system dump.
> >
> > (Does anyone know of a reason why copy_oldmem_page() would need
> >  to use uncached addresses?)
> >
> > Diffed against 2.6.36-rc3
> 
> I believe this code simply predates being able to specify the
> caching attributes at ioremap time.  Being cached in this case
> actually looks more correct, as that is the default for RAM
> and we are talking about RAM.
> 
> Ultimately either there is another cpu running wild with these pages
> mapped with some random set of attributes, and we cannot get the
> permissions right or we have captured all of the cpus and this is the
> only mapping so it doesn't matter.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Applied, thanks guys. Note, i also added a -stable tag, as kdump is 
typically used with enterprise setups and we want this (low-risk, 
high-impact) improvement to be propagated far back the -stable series.

Thanks,

	Ingo
