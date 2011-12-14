Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1LNS0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:26:33 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:32682 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755466Ab1LNS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:26:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8WAF3HgVM1kHlq80eu4e_lWGaQKkzQY1NKEHw6IJjc_TZqz
 Kg0P_ZRxOZMOy28ZGFkL8rr4jzF5wImFsttX6dPxL_adKIoobJcnt0upja9L
 4LSTsd0yDXaUKMVnDEfQAVNyKqiL8adaW0NcYM4uaV44XytV3l0.bE8nKvFd
 OJg3RnOVXbWmUokXJcQyDI78zIgCE54oRIRGNymJ8gVhs.qgKAnZKxLr9NVM
 EesUTFQu46ZrqrdCH_id5.QsibcsDaHoEaO0sYLZK2_xhOLD9DspDC2SWABk
 JgPgorlFm6wmmkq1tU5bExnPbGGXIG51fK5T.nNaGWB1b8iBJbXdHbFfQ21a
 Fj0Qmp_U5glpAQj3vHe3bige34jLpZRd1.BlnGUTL07ByfQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 14 Dec 2011 12:26:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: "Alex,Shi" <alex.shi@intel.com>, David Rientjes <rientjes@google.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323883989.2334.68.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1112141223190.16534@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>   <alpine.DEB.2.00.1112020842280.10975@router.home>   <1323419402.16790.6105.camel@debian>   <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>  
 <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>   <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>   <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>   <1323842761.16790.8295.camel@debian>  
 <1323845054.2846.18.camel@edumazet-laptop>  <1323845812.16790.8307.camel@debian>  <alpine.DEB.2.00.1112140853540.12235@router.home> <1323883989.2334.68.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Eric Dumazet wrote:

> > Many people have done patchsets like this.
>
> Things changed a lot recently. There is room for improvements.
>
> At least we can exchange ideas _before_ coding a new patchset ?

Sure but I hope we do not simply rehash what has been said before and
recode what others have code in years past.

> > There are various permutations
> > on SL?B (I dont remember them all SLEB, SLXB, SLQB etc) that have been
> > proposed over the years. Caches tend to grow and get rather numerous (see
> > SLAB) and the design of SLUB was to counter that. There is a reason it was
> > called SLUB. The U stands for Unqueued and was intended to avoid the
> > excessive caching problems that I ended up when reworking SLAB for NUMA
> > support.
>
> Current 'one active slab' per cpu is a one level cache.
>
> It really is a _queue_ containing a fair amount of objects.

In some sense you are right. It is a set of objects linked together. That
can be called a queue and it has certain cache hot effects. It is not a
qeueue in the SLAB sense meaning a configurable array of pointers.

> My initial idea would be to use a cache of 4 slots per cpu, but be able
> to queue many objects per slot, if they all belong to same slab/page.

Nick did that. Please read up on his work. I think it was named SLQB.
