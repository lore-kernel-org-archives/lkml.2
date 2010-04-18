Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0DRDGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 23:06:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33143 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776Ab0DRDGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 23:06:42 -0400
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100416164503.GH2615@linux.vnet.ibm.com>
References: <20100413034311.GB2772@linux.vnet.ibm.com>
	 <1271253110.32749.47.camel@laptop>
	 <20100415142852.GA2471@linux.vnet.ibm.com>
	 <1271425881.4807.2319.camel@twins>
	 <20100416141745.GC2615@linux.vnet.ibm.com>
	 <1271427819.4807.2353.camel@twins>
	 <20100416143202.GE2615@linux.vnet.ibm.com>
	 <1271429810.4807.2390.camel@twins>
	 <20100416150909.GF2615@linux.vnet.ibm.com>
	 <1271430855.4807.2411.camel@twins>
	 <20100416164503.GH2615@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Apr 2010 22:06:36 -0500
Message-ID: <1271559996.14589.9.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 09:45 -0700, Paul E. McKenney wrote:
> o	mutex_lock(): Critical sections need not guarantee
> 	forward progress, as general blocking is permitted.

This isn't quite right.  mutex critical sections must guarantee eventual
forward progress against the class of other potential acquirers of the
mutex otherwise the system will become either deadlocked or livelocked.

James


