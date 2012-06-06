Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2FFJ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:27:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:60232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab2FFJ1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:27:23 -0400
Message-ID: <1338974822.2749.89.camel@twins>
Subject: Re: [PATCH 2/2] [POWERPC] uprobes: powerpc port
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        oleg@redhat.com
Date: Wed, 06 Jun 2012 11:27:02 +0200
In-Reply-To: <20120606092150.GC6745@in.ibm.com>
References: <20120606091950.GB6745@in.ibm.com>
	 <20120606092150.GC6745@in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 14:51 +0530, Ananth N Mavinakayanahalli wrote:
> One TODO in this port compared to x86 is the uprobe abort_xol() logic.
> x86 depends on the thread_struct.trap_nr (absent in powerpc) to determine
> if a signal was caused when the uprobed instruction was single-stepped/
> emulated, in which case, we reset the instruction pointer to the probed
> address and retry the probe again. 

Another curious difference is that x86 uses an instruction decoder and
contains massive tables to validate we can probe a particular
instruction.

Can we probe all possible PPC instructions?
