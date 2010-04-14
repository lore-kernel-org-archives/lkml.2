Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0DNC5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:57:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:55346 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0DNC5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:57:18 -0400
Subject: Re: Possible bug with mutex adaptative spinning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1271212509.13059.135.camel@pasglop>
References: <1271212509.13059.135.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 12:56:07 +1000
Message-ID: <1271213767.13059.137.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 12:35 +1000, Benjamin Herrenschmidt wrote:
> Hi Peter !
> 
> I -may- have found a bug with mutex adaptative spinning. We hit it when
> torture testing CPU unplug.

 .../...

In fact, I wonder if there's another potential problem:

If the owner is actually running, it may do so for a very long time. It
looks to me that everybody trying to take the mutex will thus spin and
never get out of the spin loop until the owner stops running.

That sounds very wrong to me :-)

Shouldn't you at least remove the test for !owner when testing
need_resched() in __mutex_lock_common() ?

Cheers,
Ben.

