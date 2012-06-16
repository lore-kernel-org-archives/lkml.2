Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2FPRbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 13:31:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:59654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab2FPRbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 13:31:21 -0400
Message-ID: <1339867858.15222.12.camel@twins>
Subject: Re: [RFC PATCH 09/10] POWERPC: smp: remove call to
 ipi_call_lock()/ipi_call_unlock()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, axboe@kernel.dk, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Sat, 16 Jun 2012 19:30:58 +0200
In-Reply-To: <20120616163219.GI2420@linux.vnet.ibm.com>
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
	 <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
	 <20120616163219.GI2420@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-16 at 09:32 -0700, Paul E. McKenney wrote:
> However, there is an effort to get rid of stop_machine() from the
> CPU-down path...  So something else will be needed. 

Elsewhere in this thread I mentioned we could do a synchronize_sched().
I think that covers most of what stop-machine is doing these days.
