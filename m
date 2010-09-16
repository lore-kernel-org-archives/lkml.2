Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0IPQTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:19:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:59081 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0IPQTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:19:14 -0400
Subject: Re: memory barrier question
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <3777.1284638136@redhat.com>
References: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
	 <3777.1284638136@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Sep 2010 18:18:59 +0200
Message-ID: <1284653939.2275.578.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 12:55 +0100, David Howells wrote:
> If there's a lock+unlock between, then this counts as a full memory
> barrier

I though it was unlock+lock.

>From memory-barriers.txt:

And a couple of implicit varieties:

 (5) LOCK operations.

     This acts as a one-way permeable barrier.  It guarantees that all memory
     operations after the LOCK operation will appear to happen after the LOCK
     operation with respect to the other components of the system.

     Memory operations that occur before a LOCK operation may appear to happen
     after it completes.

     A LOCK operation should almost always be paired with an UNLOCK operation.


 (6) UNLOCK operations.

     This also acts as a one-way permeable barrier.  It guarantees that all
     memory operations before the UNLOCK operation will appear to happen before
     the UNLOCK operation with respect to the other components of the system.

     Memory operations that occur after an UNLOCK operation may appear to
     happen before it completes.

     LOCK and UNLOCK operations are guaranteed to appear with respect to each
     other strictly in the order specified.

     The use of LOCK and UNLOCK operations generally precludes the need for
     other sorts of memory barrier (but note the exceptions mentioned in the
     subsection "MMIO write barrier").


Therefore:

  A = 5
  LOCK

  UNLOCK
  B = 6

May be observed as:

   LOCK
   B = 6
   A = 5
   UNLOCK

The sequence:

  A = 5
  UNLOCK
  LOCK
  B = 6

Is fully ordered.
