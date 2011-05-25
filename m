Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1EYVr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:47:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab1EYVr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:47:58 -0400
Date: Wed, 25 May 2011 23:47:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110525214737.GA8955@elte.hu>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
 <20110525134414.GB19118@elte.hu>
 <BANLkTin=j2BUDoQSH-Upvg3++z9dEgLP8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin=j2BUDoQSH-Upvg3++z9dEgLP8Q@mail.gmail.com>
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


* Tony Luck <tony.luck@intel.com> wrote:

> 2011/5/25 Ingo Molnar <mingo@elte.hu>:
>
> > Btw., the SIGKILL logic is probably overcomplicated: when it's 
> > clear that user-space can not recover why not do a do_exit() and 
> > be done with it? As long as it's called from a syscall level 
> > codepath and no locks/resources are held do_exit() can be called.
> 
> There is no SIGKILL  [...]

there is one here:

mm/memory-failure.c::kill_procs_ao()

                                force_sig(SIGKILL, tk->tsk);

Which can be reached from memory_failure() in certain (justified) 
circumstances.

Thanks,

	Ingo
