Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1GKKEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:04:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1GKKEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:04:35 -0400
Date: Mon, 11 Jul 2011 12:04:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Michal Hocko <mhocko@suse.cz>,
        mingo@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
Message-ID: <20110711100418.GC9859@elte.hu>
References: <20110705062148.GA6056@program>
 <20110707131455.GB4078@tiehlicka.suse.cz>
 <4E15FBFE.4090203@linux.intel.com>
 <CAEQi4bfm7zp-Lq-Hn8JD7Dq7fOzyt2-X9Kk_jB07S_S55uC81w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEQi4bfm7zp-Lq-Hn8JD7Dq7fOzyt2-X9Kk_jB07S_S55uC81w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* wzt wzt <wzt.wzt@gmail.com> wrote:

> maybe, we can just panic() when kmalloc failed instead of add a new 
> GFP_PANIC.
> 
> new patch will coming soon.
> 
> On Fri, Jul 8, 2011 at 2:33 AM, Andi Kleen <ak@linux.intel.com> wrote:
> > When you run out of memory at early system boot (this is early
> > system boot only) the system is toast anyways. There's no way
> > to recover.
> >
> > I would just add a few GFP_PANICs and then drop the error paths.

That's a very sloppy way of doing it: should anyone ever want to 
reuse this function *not* in an init path (which is a future 
possibility with the vdso) it will have a nasty panic() embedded in 
it ...

Thanks,

	Ingo
