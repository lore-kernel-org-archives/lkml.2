Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0HWUN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:13:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab0HWUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:13:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GZMUEUBcBnCWnwMalwZYm8la5Fsa7JMeZTaNbqZRcfaHZ8Vsc4Z99eyCiCEwbN8oI
	8vfKEx9EEn0RdqC/JJPBg==
Date: Mon, 23 Aug 2010 13:13:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
In-Reply-To: <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org> <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1584180509-1282594394=:17716"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1584180509-1282594394=:17716
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 23 Aug 2010, Pekka Enberg wrote:

> > Hows about you add a helper function
> >
> >        void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
> >
> > then convert the callsites to use that, then nuke __GFP_NOFAIL?
> 
> I'd prefer killing off __GFP_NOFAIL properly :-)
> 

And how is this not done properly if it's not even needed for any of the 
allocations in this patchset since the page allocator loops forever for 
their orders and context?  (This is why we don't need to add __GFP_NOWARN 
in its place.)

This is a cleanup patchset to remove the unnecessary use of __GFP_NOFAIL, 
there _are_ GFP_KERNEL | __GFP_NOFAIL allocations that need to be 
addressed in phase three.
--531368966-1584180509-1282594394=:17716--
