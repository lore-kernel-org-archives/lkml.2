Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab1EYOOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:14:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab1EYOOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:14:45 -0400
Date: Wed, 25 May 2011 16:14:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110525141431.GF19118@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110524211644.GJ27634@elte.hu>
 <4DDC39F1.2060903@zytor.com>
 <1306332225.2211.9.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306332225.2211.9.camel@dan>
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

> I'm going to continue to enforce the requirement that 16 MB is the 
> lowest address we can safely load the kernel, and I'd still 
> appreciate any information on why 2/4 MB default alignment might 
> cause problems.

The 16 MB limit is more about preserving 24-bit addressable memory 
than about safety: it is a useful resource to certain physical 
devices and we do not want to reduce that resource by ~12.5% by 
putting a ~2MB kernel image into it.

But yes, we want to load above 16 MB, if RAM size makes it possible.

Thanks,

	Ingo
