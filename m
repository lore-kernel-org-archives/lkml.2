Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2JMJyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:54:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47650 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2JMJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:54:51 -0400
Date: Sat, 13 Oct 2012 02:54:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com> <m27gqwtyu9.fsf@firstfloor.org> <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com> <m2391ktxjj.fsf@firstfloor.org>
 <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Ezequiel Garcia wrote:

> >> SLUB is a non-starter for us and incurs a >10% performance degradation in
> >> netperf TCP_RR.
> >
> 
> Where are you seeing that?
> 

In my benchmarking results.

> Notice that many defconfigs are for embedded devices,
> and many of them say "use SLAB"; I wonder if that's right.
> 

If a device doesn't require the smallest memory footprint possible (SLOB) 
then SLAB is the right choice when there's a limited amount of memory; 
SLUB requires higher order pages for the best performance (on my desktop 
system running with CONFIG_SLUB, over 50% of the slab caches default to be 
high order).

> Is there any intention to replace SLAB by SLUB?

There may be an intent, but it'll be nacked as long as there's a 
performance degradation.

> In that case it could make sense to change defconfigs, although
> it wouldn't be based on any actual tests.
> 

Um, you can't just go changing defconfigs without doing some due diligence 
in ensuring it won't be deterimental for those users.
