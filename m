Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1EKQkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:40:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab1EKQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:40:04 -0400
Subject: Re: [PATCH] sched: fix/optimise calculation of weight-inverse
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephan =?ISO-8859-1?Q?B=E4rwolf?= 
	<stephan.baerwolf@tu-ilmenau.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nikhil Rao <ncrao@google.com>, Mike Galbraith <efault@gmx.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110511162030.GA2638@elte.hu>
References: <4DCAB351.4010204@tu-ilmenau.de> <20110511162030.GA2638@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 18:43:05 +0200
Message-ID: <1305132185.2914.251.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 18:20 +0200, Ingo Molnar wrote:
> > -            lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
> > -                / (lw->weight+1);
> > +            lw->inv_weight = WMULT_CONST / lw->weight;
> 
> hm, i definitely think there was a rounding reason for that - but apparently 
> i'm an idiot who does not add comments to non-obvious code! :-)

I suspect I might be the idiot,

> Peter, do you remember this? 

I think what we wanted to do was minimize the error:
  err = weight - inv*WMULT_CONST

by adding another term. But we could well have simply made a mess of it
instead.

