Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab0CWNSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:18:34 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:28554 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072Ab0CWNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:18:32 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
References: <1268717232.2813.36.camel@localhost>
	<1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	<20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
	<20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
	<20100322114744.GC1940@8bytes.org>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 23 Mar 2010 14:18:29 +0100
In-Reply-To: <20100322114744.GC1940@8bytes.org>
Message-ID: <ye88w9j2n2y.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.142
X-Sim: 53b345280674ca1ced024ac9fb907101448359f363725e242bb1abd56692e0ee
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Mon, Mar 22, 2010 at 11:59:27AM +0100, Ingo Molnar wrote:
> > Best would be if you demonstrated any problems of the perf symbol lookup code 
> > you are aware of on the host side, as it has that exact design you are 
> > criticising here. We are eager to fix any bugs in it.
> > 
> > If you claim that it's buggy then that should very much be demonstratable - no 
> > need to go into theoretical arguments about it.
> 
> I am not claiming anything. I just try to imagine how your proposal
> will look like in practice and forgot that symbol resolution is done at
> a later point.
> But even with defered symbol resolution we need more information from
> the guest than just the rip falling out of KVM. The guest needs to tell
> us about the process where the event happened (information that the host
> has about itself without any hassle) and which executable-files it was
> loaded from.

Slightly tangential, but there is another case that has some of the
same problems: profiling other language runtimes than C and C++, say
Python. At the moment profilers will generally tell you what is going
on inside the python runtime, but not what the python program itself
is doing.

To fix that problem, it seems like we need some way to have python
export what is going on. Maybe the same mechanism could be used to
both access what is going on in qemu and python.


Soren
