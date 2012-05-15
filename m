Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529Ab2EOPpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:45:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:53985 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965368Ab2EOPpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:45:39 -0400
Message-ID: <1337096717.27694.86.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Tue, 15 May 2012 17:45:17 +0200
In-Reply-To: <1337096141.27694.82.camel@twins>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 17:35 +0200, Peter Zijlstra wrote:
> To aid this we can add some SDTL_flags, initially I was thinking of:
> 
>  SDTL_SHARE_CORE        -- aka SMT
>  SDTL_SHARE_CACHE       -- LLC cache domain (typically multi-core)
>  SDTL_SHARE_MEMORY      -- NUMA-node (typically socket)
> 
> The 'performance' policy is typically to spread over shared resources so
> as to minimize contention on these.
> 
> If you want to add some power we need some extra flags, maybe something
> like:
> 
>  SDTL_SHARE_POWERLINE   -- power domain (typically socket)
> 
> so you know where the boundaries are where you can turn stuff off so you
> know what/where to pack bits. 

Similarly if someone fancies doing the core-hopping muck and can get the
sensor data etc..

SDTL_SHARE_TEMPERATURE could indicate cpumask that shares a temperature
sensor and needs hopping when the temperature rises to some threshold.

Assumes here is that all these mask are strongly hierarchical and don't
have weird overlaps (I'd like to meet the hardware architect who puts
SMT threads in different memory domains).
