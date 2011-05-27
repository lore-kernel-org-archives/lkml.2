Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab1E0ViN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:38:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58060 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab1E0ViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:38:12 -0400
Message-ID: <4DE0198A.9080108@zytor.com>
Date: Fri, 27 May 2011 14:37:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu> <4DDFE52D.4070308@zytor.com> <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
In-Reply-To: <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 11:05 AM, Linus Torvalds wrote:
> 
> You can load the kernel at the same virtual address we always load it,
> and/or perhaps shift it up by just small amounts (ie "single pages"
> rather than "ten bits worth of pages")
> 
> And then rely on the fact that you mixed up symbols in other ways.
> 

OK, here is a bat-shit-crazy idea... an all-module kernel where nothing
except init code is prelinked at all.

If we could modularize the core code we could have init code load the
modules at all kinds of random addresses; they wouldn't even need to be
contiguous in memory, and since we'd have full access to the memory
layout at that point, we can randomize the **** out of *everything*.

	-hpa
