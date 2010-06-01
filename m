Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab0FAEKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:10:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab0FAEKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:10:24 -0400
Date: Mon, 31 May 2010 21:05:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] Make the module 'usage' lists be two-way
In-Reply-To: <alpine.LFD.2.00.1005312051390.3637@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005312102040.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org> <201006011107.35722.rusty@rustcorp.com.au> <201006011312.22198.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312051390.3637@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Linus Torvalds wrote:
> 
> Oh. And back then, it was inside a "modlist_lock". And that lock is long 
> gone, but the GFP_ATOMIC remains.

Actually, keep it that way. Because I think that with your locking 
cleanup, we could actually turn the module_mutex back into a spinlock.

And the thing is, we don't necessarily want it to be a spinlock per se, 
but at the same time, I think that would be a good sanity test. If we can 
turn it into a spinlock without triggering the "might_sleep()" debugging 
code, that means that we are only holding it over real critical regions.

So while I don't think it needs to be a spinlock, it would be a nice added 
sanity check if it were one. We have all this helper debugging code to 
verify that spinlocked regions don't do "bad" things.

			Linus
