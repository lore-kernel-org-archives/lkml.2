Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab2EONjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:39:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2EONjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:39:11 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=N2_jc0BMHi0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=-sCVhgB4E8E2VUstdtAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337089145.14207.288.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Luming Yu <luming.yu@gmail.com>, Nick Piggin <npiggin@gmail.com>,
        Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org, jcm@jonmasters.org
Date: Tue, 15 May 2012 09:39:05 -0400
In-Reply-To: <1337087170.27020.166.camel@laptop>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	 <CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
	 <CAJRGBZy0S_fg3GY4S5CG-2SWv5AG1jMrcMMqCiTg=7xyD1mrzQ@mail.gmail.com>
	 <1337087170.27020.166.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 15:06 +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-15 at 20:58 +0800, Luming Yu wrote:
> > 
> > 
> > Both __native_flush_tlb() and __native_flush_tlb_single(...)
> > introduced roughly 1 ns  latency to tsc sampling executed in
> > stop_machine_context in two logical CPUs 
> 
> But you have to weight that against the cost of re-population, and
> that's the difficult bit, since we have no clue how many tlb entries are
> in use by the current cr3.
> 
> It might be possible for intel to give us this information, I've asked
> for something similar for cachelines.

What information? The # of tlb entries in use?

-- Steve


