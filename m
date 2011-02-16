Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1BPUQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:16:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1BPUQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:16:03 -0500
Date: Wed, 16 Feb 2011 21:15:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110216201524.GA7839@elte.hu>
References: <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <alpine.LFD.2.00.1102152125180.26192@localhost6.localdomain6>
 <20110215225234.GP5935@random.random>
 <alpine.LFD.2.00.1102160002300.26192@localhost6.localdomain6>
 <20110215231733.GR5935@random.random>
 <1297850294.2413.30.camel@twins>
 <20110216101521.GU5935@random.random>
 <20110216102801.GA23082@elte.hu>
 <20110216144947.GA5935@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216144947.GA5935@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Arcangeli <aarcange@redhat.com> wrote:

> Ok sorry, but whenever I'm asked if I tested my patch with lockdep, I think if it 
> was tested for other bugs, not to remove debug code overlapping with some lockdep 
> feature.

ah, ok. The thing is, if it was only a single VM_BUG_ON() then it wouldnt be a big 
deal. Seven seems excessive - especially since we have that very check via lockdep.

Thanks for removing them!

	Ingo
