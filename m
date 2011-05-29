Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1E2Mr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 08:47:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56979 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab1E2Mr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 08:47:27 -0400
Date: Sun, 29 May 2011 14:47:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110529124702.GE26627@elte.hu>
References: <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <4DDFE52D.4070308@zytor.com>
 <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
 <20110528121820.GB12059@elte.hu>
 <4DE19DC3.7090106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE19DC3.7090106@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/28/2011 05:18 AM, Ingo Molnar wrote:
> > 
> > Having half a megabyte of '__init buffer' at the beginning or end 
> > of the kernel image is no big deal, it's more than enough for 
> > good randomization and makes the whole thing image-loader 
> > invariant: we can freely shift the 'real' kernel image within 
> > this larger boundary without consulting RAM maps.
> 
> Sure, but you're also blowing any attempt at PMD alignment to 
> kingdom come.

Do you mean we'd not start at a 2MB boundary and thus would waste on 
average an about 0.125 worth of huge-TLB cache entry?

That does not look like a very big issue to me - but maybe i'm 
missing something and you mean something else.

Thanks,

	Ingo
