Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2JUN31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 09:29:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61226 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2JUN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 09:29:26 -0400
Date: Sun, 21 Oct 2012 15:29:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 4/2] numa, mm: Rename the PROT_NONE fault handling
 functions
Message-ID: <20121021132921.GA23425@gmail.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
 <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
 <1350646863.30157.13.camel@twins>
 <50815EA5.5080502@redhat.com>
 <20121019205407.GA9132@gmail.com>
 <20121021125007.GB19535@gmail.com>
 <5083F720.2030003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5083F720.2030003@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 10/21/2012 08:50 AM, Ingo Molnar wrote:
> >
> >* Ingo Molnar <mingo@kernel.org> wrote:
> >
> >>>>I don't much care either way, but I was thinking walken
> >>>>might want to use something similar to do WSS estimation,
> >>>>in which case the NUMA name is just as wrong.
> >>>
> >>>That's a good point. I had not considered other uses of the
> >>>same code.
> >>
> >>Renaming the functions for more clarity still makes sense IMO:
> >>we could give it a _wss or _working_set prefix/postfix?
> >
> >So, to not drop your patch on the floor I've modified it as per
> >the patch below.
> >
> >The _wss() names signal that these handlers are used for a
> >specific purpose, they are not related to the regular PROT_NONE
> >handling code.
> 
> Michel indicated that he does not use PROT_NONE for his 
> working set estimation code, but instead checks the accessed 
> bits in the page tables.

The pte_young() WSS method has a couple of fundamental 
limitations:

 - it doesn't work with shared memory very well, the pte is per
   mapping, not per page. The PROT_NONE method instruments the
   physical page in essence.

 - it does not tell us which task touched the pte, in a
   multi-threaded program

So like Peter I'd too expect these new WSS methods to eventually 
be picked up for any serious WSS work.

Thanks,

	Ingo
