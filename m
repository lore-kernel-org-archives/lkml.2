Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1JZU0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:26:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1JZU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:26:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=vCnQs4nYfgVreoXEIZcD6MBt+cXsVviTBOEIMOBht7QJ0stC6u/7GmyWbQcOnsSrH
	rAHZYR8qlOO4HLR7eQw6A==
Date: Wed, 26 Oct 2011 13:26:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Philipp Herz - Profihost AG <p.herz@profihost.ag>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
In-Reply-To: <4EA506B9.4030604@profihost.ag>
Message-ID: <alpine.DEB.2.00.1110261322460.23111@chino.kir.corp.google.com>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org> <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com> <4EA506B9.4030604@profihost.ag>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011, Philipp Herz - Profihost AG wrote:

> we have recompiled the kernel of one machine with CONFIG_SLUB instead of
> CONFIG_SLAB, but it is showing similar message.
> 
> Now it's showing failure at "order:5, mode:0x4020".
> 
> Call trace can be found at:
> * http://pastebin.com/uGJiwvG1
> 
> Comparing kernel 2.6.32 (mm/page_alloc.c) there seams to be the same way of
> dealing with page allocation.
> 
> Do you have an idea why these (warning) messages do never appear running
> 2.6.32?
> 

Do you have CONFIG_COMPACTION enabled?  Perhaps this is a difference in 
the deprecation of lumpy reclaim between 2.6.35 and 2.6.38 and 
defragmentation being done by memory compaction instead.

It won't be triggered synchronously in this context since it's a 
GFP_ATOMIC allocation, which is why it emits a page allocation failure in 
the first place, but it will show whether defragmentation is the issue or 
you're just simply low on memory.
