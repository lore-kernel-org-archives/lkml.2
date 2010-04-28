Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0D1EqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:46:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:44331 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0D1EqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:46:18 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1272429513.24542.83.camel@pasglop>
References: <1272429513.24542.83.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 14:39:34 +1000
Message-ID: <1272429574.24542.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 14:38 +1000, Benjamin Herrenschmidt wrote:
> Currently, we can hit a nasty case with optimistic spinning on mutexes:
> 
>     CPU A tries to take a mutex, while holding the BKL
> 
>     CPU B tried to take the BLK while holding the mutex
> 
> This looks like a AB-BA scenario but in practice, is allowed and happens
> due to the auto-release-on-schedule nature of the BKL.

 .../...

BTW. The patch is only compile-tested so far :-) It's going to be
hammered with the test case that triggered the original bug hopefully
tonight.

Cheers,
Ben.


