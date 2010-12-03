Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab0LCODV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:03:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:57106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab0LCODU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:03:20 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <20101203133056.GF27994@linux.vnet.ibm.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <1291382619.32004.2124.camel@laptop>
	 <20101203133056.GF27994@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 15:03:30 +0100
Message-ID: <1291385010.32004.2165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 19:00 +0530, Srivatsa Vaddagiri wrote:
> On Fri, Dec 03, 2010 at 02:23:39PM +0100, Peter Zijlstra wrote:
> > Right, so another approach might be to simply swap the vruntime between
> > curr and p.
> 
> Can't that cause others to stave? For ex: consider a cpu p0 having these tasks:
> 
> p0 ->  A0 B0 A1
> 
> A0/A1 have entered some sort of AB<->BA spin-deadlock, as a result A0 wants to
> direct yield to A1 which wants to direct yield to A0. If we keep swapping their
> runtimes, can't it starve B0?

No, because they do receive service (they spend some time spinning
before being interrupted), so the respective vruntimes will increase, at
some point they'll pass B0 and it'll get scheduled.


