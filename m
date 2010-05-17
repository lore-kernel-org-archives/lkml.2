Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0EQWEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:04:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:41354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0EQWEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:04:41 -0400
Subject: Re: [PATCH 01/35] lmb: prepare x86 to use lmb to replace early_res
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BF18500.60105@zytor.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-2-git-send-email-yinghai@kernel.org>
	 <1273803143.21352.353.camel@pasglop>  <4BECEB8D.8070600@oracle.com>
	 <1273824578.21352.579.camel@pasglop>  <4BF18500.60105@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 08:02:29 +1000
Message-ID: <1274133749.21352.756.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 11:03 -0700, H. Peter Anvin wrote:
> On 05/14/2010 01:09 AM, Benjamin Herrenschmidt wrote:
> > 
> > No. That is not the point. Read the rest of my email !
> > 
> > We need to -sanitize- those errors. _Maybe_ exposing LMB_ERROR is the
> > right way to do so, but in that case, we need to make -all- function use
> > the same error code. Right now, some fail with 0 and some with
> > LMB_ERROR.
> > 
> 
> Using errnos like the rest of the kernel seems like the right thing to
> do, IMO.

Maybe. The allocator/find functions return a physical address. If we all
agree that a physical address between -PAGE_SIZE and 0 is never valid,
then we can overlay the negative errno codes like we do for pointers.

I'll have a look at that, it shouldn't be very hard.

Cheers,
Ben.


