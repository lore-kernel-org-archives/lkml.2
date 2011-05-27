Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1E0Nqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:46:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1E0Nqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:46:34 -0400
Date: Fri, 27 May 2011 15:46:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527134617.GD23626@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110526203502.GK29496@redhat.com>
 <20110526204030.GL29496@redhat.com>
 <1306442674.2279.29.camel@dan>
 <20110527131313.GB8053@redhat.com>
 <1306502492.3339.2.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306502492.3339.2.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> > And if this randomization is also to protect information from 
> > root user then /proc/iomem exporting the physical address of 
> > kernel is still a valid question in that context.
> 
> I think we can deal with unprivileged users first, and if we want 
> to truly prevent root from finding this out, we can introduce a 
> separate toggle that locks things down further.

Correct, the case of unprivileged users should be handled first and 
it should be handled separately from any root-restrictions.

I only raised this to have a rough record of what would have to 
happen there.

Once all is said, done, committed and tested (the last two not 
necessarily in that order), we can look at any open root-restrict 
questions. It's a lot less clear-cut from a system usability POV.

If we do it we probably want one central one-shot 'restrict root from 
now on' toggle, not the separate switches that kill kexec and module 
loading separately.

Some shops might even want to disable root from being able to reboot 
the system and restrict reboots to physically performed (and 
crash/panic/hang induced) reboots only.

Some shops might want to make reboots dependent on the provision of a 
secret key. That key would not be stored on that system.

So there's lots of details to sort out in the "keep root from being 
able to break into the kernel and hide a rootkit out and disappear" 
area.

Thanks,

	Ingo
