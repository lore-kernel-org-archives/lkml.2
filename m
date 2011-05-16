Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1EPNAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:00:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab1EPNAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:00:47 -0400
Date: Mon, 16 May 2011 15:00:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>, oleg@redhat.com,
        vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re: [PATCH
 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110516130032.GF7128@elte.hu>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
 <20110515171748.GA25216@host1.jankratochvil.net>
 <20110515172811.GM23665@htj.dyndns.org>
 <20110515200654.GA32659@host1.jankratochvil.net>
 <20110516084350.GO23665@htj.dyndns.org>
 <20110516121711.GC10469@host1.jankratochvil.net>
 <20110516125615.GW23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516125615.GW23665@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Mon, May 16, 2011 at 02:17:11PM +0200, Jan Kratochvil wrote:
> > On Mon, 16 May 2011 10:43:50 +0200, Tejun Heo wrote:
> > > There's distinction between "broken" and "ugly".  If it's ugly but
> > > functional, you don't need to "fix" it.
> > 
> > The final goal is the user experience (such as the users of GDB), nothing else
> > matters.  If it is so "ugly" the userland developers fail to use it the
> > project as a whole still broken.
> 
> To me, it seems the breakage and mountain of workarounds come more from lack 
> of proper documentation plus the current ptrace + job control + signal 
> interaction which is really broken.  For example, it seems nobody really 
> understood how group stop and ptrace interacts and the different types of 
> traps being used - strace(2) thought the same signal was being delivered 
> twice.

Btw., i'd also like to offer the observation that even these days, running 
brand-new Rawhide distribution with strace-4.5.20-2.fc15.x86_64 and a fresh 
kernel, i *still* often see strace (or ptrace?) misbehavior like it 
misprocessing Ctrl-C and leaving hung threads around which i have to clean up 
manually ...

So if you could bring sanity in here i think we could live with a regression or 
two, if the situation could be improved in the longer run - it's not like we 
are protecting a stable bastion of robust functionality here ...

Thanks,

	Ingo
