Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2JUNns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 09:43:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50045 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2JUNnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 09:43:47 -0400
Date: Sun, 21 Oct 2012 15:43:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 4/2] numa, mm: Rename the PROT_NONE fault handling
 functions
Message-ID: <20121021134341.GA23820@gmail.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
 <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
 <1350646863.30157.13.camel@twins>
 <50815EA5.5080502@redhat.com>
 <20121019205407.GA9132@gmail.com>
 <20121021125007.GB19535@gmail.com>
 <5083F720.2030003@redhat.com>
 <20121021132921.GA23425@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021132921.GA23425@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > Michel indicated that he does not use PROT_NONE for his 
> > working set estimation code, but instead checks the accessed 
> > bits in the page tables.
> 
> The pte_young() WSS method has a couple of fundamental 
> limitations:
> 
>  - it doesn't work with shared memory very well, the pte is per
>    mapping, not per page. The PROT_NONE method instruments the
>    physical page in essence.
> 
>  - it does not tell us which task touched the pte, in a
>    multi-threaded program
> 
> So like Peter I'd too expect these new WSS methods to eventually 
> be picked up for any serious WSS work.

Nevertheless lets wait and see until it actually happens - and 
meanwhile the prot_none namings are confusing.

So I've applied your patch as-is, with two more (new) usage 
sites converted as well. Will push it out after a bit of 
testing.

Thanks,

	Ingo
