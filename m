Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2JSK3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:29:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43875 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753419Ab2JSK3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:29:37 -0400
Message-ID: <1350642576.11308.13.camel@joe-AO722>
Subject: Re: [PATCH net-next 00/21] treewide: Use consistent api style for
 address testing
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Oct 2012 03:29:36 -0700
In-Reply-To: <1350630254.2293.183.camel@edumazet-glaptop>
References: <cover.1350618006.git.joe@perches.com>
	 <1350630254.2293.183.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed over long cc list from original 00/21 post)

On Fri, 2012-10-19 at 09:04 +0200, Eric Dumazet wrote:
> On Thu, 2012-10-18 at 20:55 -0700, Joe Perches wrote:
> > ethernet, ipv4, and ipv6 address testing uses 3 different api naming styles.
> > 
> > ethernet uses:	is_<foo>_ether_addr
> > ipv4 uses:	ipv4_is_<foo>
> > ipv6 uses:	ipv6_addr_<foo>
> > 
> > Standardize on the ipv6 style of <prefix>_addr_<type> to reduce
> > the number of styles to remember.
[]
> Yes they are some names discrepancies, thats a big deal.

missing a not maybe?

> And we have alloc_skb() / kfree_skb() / skb_clone() 
> Why not skb_alloc() / skb_free() / skb_clone() ?

Not really a similar use case to this renaming, as alloc/free
functions generally start with alloc/free.

These particular functions all refer to address tests.

> Some people actually know current code by name of functions, they dont
> want to change their mind and having to grep include files and git log
> to learn the new names of an old function, especially when traveling and
> using a laptop.
> 
> Sure, when we want to use eth_random_addr(), a grep into include files
> to check if its still the right name (old one was random_ether_addr())
> is OK because we dont use this one often.
> 
> If you think about it, eth_random_addr() was not the perfect name.

Luckily, that one's only got 46 references.
I don't care for the <type>_<action>_addr vs <type>_addr_<test>
use either.  Maybe a set in the name would have been/still be better.

> Think about all the documentation you can find outside of kernel tree,
> RFC and things like that, copy/pasting some linux kernel code.
> 
> This kind of changes make our life more difficult, when we have to
> backport patches or rebase code, or even perform some searches to find
> prior issues/discussions.
> 
> Life of a kernel developer is not only dealing with latest Linus (or
> -next) tree, and using automatic 'tools'.
> 
> Thats a real pain for me at least.

Pity, api consistency has some value.

cheers, Joe

