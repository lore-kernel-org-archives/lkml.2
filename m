Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0CZRr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:47:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab0CZRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:47:24 -0400
Date: Fri, 26 Mar 2010 10:42:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Scott Lurndal <scott.lurndal@3leafsystems.com>
cc: David Howells <dhowells@redhat.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
In-Reply-To: <20100326173730.GA27489@pendragon.3leafnetworks.com>
Message-ID: <alpine.LFD.2.00.1003261038160.3721@i5.linux-foundation.org>
References: <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326173730.GA27489@pendragon.3leafnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Mar 2010, Scott Lurndal wrote:
> 
> I wonder if Intel's EM64 stuff makes this more deterministic, perhaps
> David's implementation would work for x86_64 only?

Limiting it to x86-64 would certainly remove all the worries about all the 
historical x86 clones.

I'd still worry about it for future Intel chips, though. I absolutely 
_detest_ relying on undocumented features - it pretty much always ends up 
biting you eventually. And conditional writeback is actually pretty nasty 
from a microarchitectural standpoint.

			Linus
