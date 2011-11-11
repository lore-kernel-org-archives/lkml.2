Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1KKEbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:31:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:53993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1KKEbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:31:46 -0500
Message-ID: <1320985863.21206.40.camel@pasglop>
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, nai.xia@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org,
        linux@arm.linux.org.uk
Date: Fri, 11 Nov 2011 15:31:03 +1100
In-Reply-To: <alpine.LSU.2.00.1111101723500.1239@sister.anvils>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
	 <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com>
	 <4EBC085D.3060107@jp.fujitsu.com> <1320959579.21206.24.camel@pasglop>
	 <alpine.LSU.2.00.1111101723500.1239@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 18:09 -0800, Hugh Dickins wrote:
> It was in this mail below, when Andrew sent Linus the patch, and Linus
> opposed my "argument" in support: that wasn't on lkml or linux-mm,
> but I don't see that its privacy needs protecting.
> 
> KOSAKI-san then sent instead a patch to correct some ints to longs,
> which Linus did put in: but changing them to a new "vm_flags_t".
> 
> He was, I think, hoping that one of us would change all the other uses
> of unsigned long vm_flags to vm_flags_t; but in fact none of us has
> stepped up yet - yeah, we're still sulking that we didn't get our
> shiny new 64-bit vm_flags ;)
> 
> I think Linus is not opposed to PowerPC and others defining a 64-bit
> vm_flags_t if you need it, but wants not to bloat the x86_32 vma.
> 
> I'm still wary of the contortions we go to in constraining flags,
> and feel that the 32-bit case holds back the 64-bit, which would
> not itself be bloated at all.
> 
> The subject is likely to come up again, more pressingly, with page
> flags.

Right, tho the good first step is to convert everything to vm_flags_t so
we can easily switch if we want to, even on a per-arch basis...

Oh well, now all we need is a volunteer :-)

Cheers,
Ben.


