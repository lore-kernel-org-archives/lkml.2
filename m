Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1C2WiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:38:18 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:31254 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751360Ab1C2WiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:38:17 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: geuAgLMVM1kMWvjbKRVpG.xUPQbJh7iChyxhqcmwZSJzRnC
 DL7KGSFLkT3JS01ajJmroj8g4p_WxQRxlFMJr1PG6HpRvokDzRx.OfU1En8B
 _Lohh9prsbeIgmcghCTKpVqFcn2xVnSzacQ8CwxC5xL_WapMNVKhnXV.bUZY
 k2..LHLXUZrKeuE7QzEMx6L17lcSMJ_9fzubvMiLW_4eIYHHhXHp.fe9ai4L
 W6Jtp047PAa8fDxOLcbQLAobkYgJPrsiP.tPtxcKAG7grh1GCtekvvJb_LMw
 d6v2lyzRJTG0h4P_vj7vEYEAY0y8TfC5XkxlGilo0PLKzS_YIr4dkO3Yti8_
 5E2wI3CPDKeCjGBdB6wHdgJat
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 29 Mar 2011 17:38:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Shaohua Li <shaohua.li@intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: add alignment for some variables
In-Reply-To: <20110329152434.d662706f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1103291734001.11817@router.home>
References: <1301277536.3981.27.camel@sli10-conroe> <m2oc4v18x8.fsf@firstfloor.org> <1301360054.3981.31.camel@sli10-conroe> <20110329152434.d662706f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Andrew Morton wrote:

> > -struct percpu_counter vm_committed_as;
> > +struct percpu_counter vm_committed_as ____cacheline_internodealigned_in_smp;
>
> Why ____cacheline_internodealigned_in_smp?  That's pretty aggressive.
>
> afacit the main benefit from this will occur if the read-only
> vm_committed_as.counters lands in the same cacheline as some
> write-frequently storage.
>
> But that's a complete mad guess and I'd prefer not to have to guess.

It would  be useful to have some functionality that allows us to give
hints as to which variables are accessed together and therefore would be
useful to put in the same cacheline. Thus avoiding things like the
readmostly segment and the above aberration.

Andi had a special pda area in earlier version before the merger of 32 and
64 bit code for x86 that resulted in placement of the most performance
critical variables near one another. I am afraid now they are all spread
out.

So maybe something that allows us to define multiple pdas? Or just structs
that are cacheline aligned?

