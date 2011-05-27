Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1E0RBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:01:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42722 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1E0RBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:01:07 -0400
Date: Fri, 27 May 2011 19:00:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527170045.GB4356@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
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

> If you compile your own kernel version, you're already home free, 
> and load-time randomization is pointless.

Most successful exploits work in two steps: first a local exploit 
(weak password with a user, stupid script escaping bug, or a buffer 
overflow somewhere), then a local kernel exploit to gain root and 
kernel access. (for a rootkit and what not)

Straight remote root exploits are pretty rare - and per system 
relinking only protects against that.

The problem with your relinking solution is that a local attacker can 
easily figure out where the kernel is. So this does not protect 
against the more common break-in scenario.

Kernel image randomization makes this last step really 
indeterministic and thus dangerous to attackers.

Thanks,

	Ingo
