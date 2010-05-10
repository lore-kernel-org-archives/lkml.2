Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0EJLjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:39:09 -0400
Received: from ozlabs.org ([203.10.76.45]:35110 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab0EJLjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:39:07 -0400
Date: Mon, 10 May 2010 21:38:57 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Add group scheduling transactional APIs
Message-ID: <20100510113857.GA5131@brick.ozlabs.ibm.com>
References: <1272002160.5707.60.camel@minggr.sh.intel.com>
 <tip-6bde9b6ce0127e2a56228a2071536d422be31336@git.kernel.org>
 <1273269355.1642.383.camel@laptop>
 <20100508102841.GA10650@brick.ozlabs.ibm.com>
 <1273479115.5605.3329.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273479115.5605.3329.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 10:11:55AM +0200, Peter Zijlstra wrote:

> Can't you compute n_txn_start by subtracting n_added from n_events ?

Well, n_added says how many have been added since hw_perf_disable, and
we could get multiple transactions inside a hw_perf_disable/enable
pair, if we're scheduling multiple groups on.  So n_events - n_added
doesn't tell us how many have been added in this transaction -- unless
I'm mistaken and there is a one transaction per hw_perf_disable/enable
rule, but I didn't see that written anywhere, and it does seem to be
explicitly one transaction per group.

Paul.
