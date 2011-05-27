Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1E0Rq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:46:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1E0Rq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:46:58 -0400
Date: Fri, 27 May 2011 19:46:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527174644.GG4356@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, May 27, 2011 at 10:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Well, 'fixing the info leaks' will obfuscate previously useful files
> > such as /proc/kallsyms ...
> 
> Guys, stop with the crazy already.
> 
> YOU HAVE TO DO THAT FOR THE LINK-TIME-OBFUSCATION TOO!
>
> > That's one of the advantages of randomization: it allows us to 
> > expose RIPs without them being an instant information leak.
> 
> Except you clearly aren't thinking that through AT ALL.
> 
> The obfuscation of things like /proc/kallsyms is *exactly*the*same* 
> whether you do the randomization at boot-time or install-time.

Well, but two mails ago you said:

> And load-time randomization has all these nasty problems with 
> memory maps etc, because we obviously have to shift the whole 
> kernel around by some fixed offset. But if there was some way to 
> just re-link the distro kernel easily, then it could be done by the 
> kernel install scripts, and it could potentially do more than just 
> "shift up load address by some random number".

If i understood you correctly you suggest randomizing the image by 
shifting the symbols in it around. The boot loader would still load 
an 'image' where it always loads it - just that image itself is 
randomized internally somewhat, right?

( because that's the only way we can avoid the problems with e820 
  memory maps which you referred to, if don't actually change the 
  load address. )

Have i understood you correctly?

Thanks,

	Ingo
