Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2LUPtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:49:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LUPtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:49:08 -0500
Message-ID: <1356104944.4547.42.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.6-rt17
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 16:49:04 +0100
In-Reply-To: <alpine.LFD.2.02.1212211520570.3148@ionos>
References: <alpine.LFD.2.02.1211122223300.10000@ionos>
	 <1356087972.4547.26.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1212211520570.3148@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:cAgiifoMSQfLAAiWaqejKb5Vvc8UMV3B/7RDF060m1N
 K/PXRal7mfdqmJjNzQl1++SQ4C62t+YZ8iVu0QMelI/ivzBgyX
 emmy88b3gkUv9kB0ezNFP6wbEZvmGkMu2xEMMIGxIlmcZy51yM
 r+ibuPhsChHzDGC/5IoqKgQEtPLsxGXRgK/TpS5DExJaLn91VS
 UpXrBEW05gEPkeOpm/333qpD5cC7VUoNKTnNZ9+KoUqFAjjCzb
 GcSp+LDW/RwVSOPA791RsLFBEgD+BAEauWxWrOO0JmUv3vx79N
 Z8P7vHAlX3HN/G+6eJFOlaAveZFB26NTLXntqoMsVB2zfHlZqe
 GVGQjPujYlrPw56GSx8inFs7Z/tXk1qXJbsz9/s9wjW7PEgVpa
 8olxMvX7YISCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 15:23 +0100, Thomas Gleixner wrote: 
> On Fri, 21 Dec 2012, Mike Galbraith wrote:
> > On Mon, 2012-11-12 at 22:28 +0100, Thomas Gleixner wrote: 
> > > Dear RT Folks,
> > > 
> > > I'm pleased to announce the 3.6.6-rt17 release. 3.6.6-rt16 is just a
> > > not announced update release to 3.6.6.
> > > 
> > > Changes since 3.6.6-rt16:
> > > 
> > >    * Finally make the NOHZ softirq pending detection work with the new
> > >      softirq scheme.
> > 
> > Well, almost.  They gripe when rebooting, but I haven't seen one other
> > than that.  This is 3.6.11-rt23 on a 64 core DL980 I set up to run some
> > latency tests on.
> 
> Yeah. It's not fixed completely. I know what it needs but thats major
> surgery.
>  
> > [  318.692463] kvm: exiting hardware virtualization
> > [  319.568482] Disabling non-boot CPUs ...
> > [  319.647819] NOHZ: local_softirq_pending 80
> > [  319.876148] NOHZ: local_softirq_pending 202
> > [  319.876172] NOHZ: local_softirq_pending 202
> > [  319.988912] NOHZ: local_softirq_pending 282
> > [  320.097066] NOHZ: local_softirq_pending 202
> > [  320.321428] NOHZ: local_softirq_pending 80
> > [  320.662601] NOHZ: local_softirq_pending 202
> > [  320.662637] NOHZ: local_softirq_pending 202
> > [  323.162636] NOHZ: local_softirq_pending 202
> > [  323.162649] NOHZ: local_softirq_pending 202
> > [  325.217675] Restarting system.
> > 
> > Don't suppose you know why LAZY_PREEMPT would make 3.0-rt explode if you
> > turn on wakeup_rt tracer do you?
> 
> No.

Aw poo.  Tracing goop is hard. 

> > I backported that and your softirq changes to 3.0.  New softirq handling
> > scheme work spiffy there, LAZY_PREEMPT works fine too.. until you turn
> > tracing on, then it corrupts memory, and makes mushroom cloud.
> 
> I guess you are just trying to make up for the canceled apocalypse :)

Damn.  I forgot to run around yelling "The sky is falling!" :)

-Mike 


