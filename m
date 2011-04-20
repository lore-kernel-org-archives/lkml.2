Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab1DTLFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:05:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:45326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1DTLFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:05:21 -0400
Subject: Re: [PATCH 13/20] lockdep, mutex: Provide mutex_lock_nest_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <20110419130654.95a14117.akpm@linux-foundation.org>
References: <20110401121258.211963744@chello.nl>
	 <20110401121725.940769985@chello.nl>
	 <20110419130654.95a14117.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Apr 2011 13:03:56 +0200
Message-ID: <1303297436.8345.158.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 13:06 -0700, Andrew Morton wrote:
> On Fri, 01 Apr 2011 14:13:11 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Provide the mutex_lock_nest_lock() annotation.
> 
> why?
> 
> Neither the changelog nor the code provide any documentation for this addition to
> the lokdep API.

---
Subject: lockdep, mutex: Provide mutex_lock_nest_lock                                        
From: Peter Zijlstra <a.p.zijlstra@chello.nl>                                                
Date: Fri, 26 Nov 2010 15:39:00 +0100                                                        
                                                                                             
In order to convert i_mmap_lock to a mutex we need a mutex equivalent                        
to spin_lock_nest_lock(), thus provide the mutex_lock_nest_lock()                            
annotation.                                                                                  
                                                                                             
As with spin_lock_nest_lock(), mutex_lock_nest_lock() allows                                 
annotation of the locking pattern where an outer lock serializes the                         
acquisition order of nested locks. That is, if every time you lock                            
multiple locks A, say A1 and A2 you first acquire N, the order of                            
acquiring A1 and A2 is irrelevant.                                                           
                                                                                             
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>  
---
