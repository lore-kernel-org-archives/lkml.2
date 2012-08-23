Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab2HWKHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:07:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:48907 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab2HWKHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:07:34 -0400
Message-ID: <1345716378.29170.4.camel@pasglop>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, ananth@in.ibm.com,
        ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, peterz@infradead.org,
        oleg@redhat.com, Ingo Molnar <mingo@elte.hu>
Date: Thu, 23 Aug 2012 20:06:18 +1000
In-Reply-To: <20120823053234.GE25338@linux.vnet.ibm.com>
References: <20120822082205.GA29216@in.ibm.com>
	 <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia>
	 <20120823053234.GE25338@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 11:02 +0530, Srikar Dronamraju wrote:
> > 
> 
> insn is updated/accessed in the arch independent code. Size of
> uprobe_opcode_t could be different for different archs.
> uprobe_opcode_t
> represents the size of the smallest breakpoint instruction for an
> arch.
> 
> Hence u8 works out the best. I know we could still use uprobe_opcode_t
> and achieve the same. In which case, we would have to interpret
> MAX_UINSN_BYTES differently. Do you see any advantages of using
> uprobe_opcode_t instead of u8 across archs?

But don't you actively rely on the fact that on powerpc, unlike x86, you
-can- atomically replace an instruction with a single 32-bit store ?

If you don't you should consider it, and that makes defining this as a
u8 array non-sensical (as is using memcpy)

Ben.


