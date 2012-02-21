Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2BUKRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:17:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:35676 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2BUKRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:17:39 -0500
Message-ID: <1329819437.2293.382.camel@twins>
Subject: Re: [PATCH 0/2 x86] fix some page faults in nmi if kmemcheck is
 enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Date: Tue, 21 Feb 2012 11:17:17 +0100
In-Reply-To: <1329788560.3448.45.camel@ThinkPad-T61>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 09:42 +0800, Li Zhong wrote:

> > Hell no, these are some of the ugliest patches I've seen in a while. Not
> > to mention that their changelogs are utter crap since they don't even
> > explain why they're doing what they're doing.
> > 
> Hi Peter, 
> 
> I agree that the fix is ugly. I'm willing to change if there are some
> better ways. 

There are always better ways..

> The problem here is: 
> 1. It seems x86 doesn't allow page faults in nmi, and there are checks
> in the code, like WARN_ON_ONCE(in_nmi()).

I bet that's not x86 only..

> 2. If CONFIG_KMEMCHECK is enabled, the pages allocated through slab will
> be marked as non-present, to capture uninitialized memory access. More
> information in Documentation/kmemcheck.txt .

So then kmemcheck is buggy, since the nmiaction structure is initialized
in register_nmi_handler(), so it should most definitely not be marked
non-present.

> 3. From the log, there are some memories accessed in nmi, which are in
> pages marked as non-present by kmemcheck, as they are allocated by
> something like kmalloc(). 

So figure out why and fix that instead of writing ugly ass patches that
seemingly work around the problem without actually thinking about it.
