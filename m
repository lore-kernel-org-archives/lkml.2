Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2GZILw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:11:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:54245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2GZILt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:11:49 -0400
Message-ID: <1343290299.26034.84.camel@twins>
Subject: Re: [RFC] page-table walkers vs memory order
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 26 Jul 2012 10:11:39 +0200
In-Reply-To: <alpine.LSU.2.00.1207251452160.2084@eggly.anvils>
References: <1343064870.26034.23.camel@twins>
	 <alpine.LSU.2.00.1207241356350.2094@eggly.anvils>
	 <20120725175628.GH2378@linux.vnet.ibm.com>
	 <alpine.LSU.2.00.1207251313180.1942@eggly.anvils>
	 <20120725211217.GR2378@linux.vnet.ibm.com>
	 <alpine.LSU.2.00.1207251452160.2084@eggly.anvils>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 15:09 -0700, Hugh Dickins wrote:
> We find out after it hits us, and someone studies the disassembly -
> if we're lucky enough to crash near the origin of the problem. 

This is a rather painful way.. see

  https://lkml.org/lkml/2009/1/5/555

we were lucky there in that the lack of ACCESS_ONCE() caused an infinite
loop so we knew exactly where we got stuck.


