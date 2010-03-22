Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0CVM0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:26:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab0CVM0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:26:16 -0400
Date: Mon, 22 Mar 2010 13:26:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100322122604.GI3483@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <1268969929.2813.184.camel@localhost>
 <20100319082122.GE12576@elte.hu>
 <20100319172903.GI13108@8bytes.org>
 <20100321184300.GB25922@elte.hu>
 <20100322101451.GK13108@8bytes.org>
 <20100322105927.GB3483@elte.hu>
 <20100322114744.GC1940@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322114744.GC1940@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joro@8bytes.org> wrote:

> On Mon, Mar 22, 2010 at 11:59:27AM +0100, Ingo Molnar wrote:
> > Best would be if you demonstrated any problems of the perf symbol lookup code 
> > you are aware of on the host side, as it has that exact design you are 
> > criticising here. We are eager to fix any bugs in it.
> > 
> > If you claim that it's buggy then that should very much be demonstratable - no 
> > need to go into theoretical arguments about it.
> 
> I am not claiming anything. I just try to imagine how your proposal will 
> look like in practice and forgot that symbol resolution is done at a later 
> point.
>
> But even with defered symbol resolution we need more information from the 
> guest than just the rip falling out of KVM. The guest needs to tell us about 
> the process where the event happened (information that the host has about 
> itself without any hassle) and which executable-files it was loaded from.

Correct - for full information we need a good paravirt perf integration of the 
kernel bits to pass that through. (I.e. we want to 'integrate' the PID space 
as well, at least within the perf notion of PIDs.)

Initially we can do without that as well.

> Probably. At least it is the solution that fits best into the current design 
> of perf. But we should think about how this will be done. Raw disk access is 
> no solution because we need to access virtual file-systems of the guest too. 
> [...]

I never said anything about 'raw disk access'. Have you seen my proposal of 
(optional) VFS namespace integration? (It can be found repeated the Nth time 
in my mail you replied to)

Thanks,

	Ingo
