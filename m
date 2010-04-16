Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0DPOg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:36:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44395 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab0DPOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:36:26 -0400
Subject: Re: [RFC PATCH 1/2] hw-breakpoints: Separate constraint space for
 data and instruction breakpoints
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1271113280-10521-2-git-send-regression-fweisbec@gmail.com>
References: <1271113280-10521-1-git-send-regression-fweisbec@gmail.com>
	 <1271113280-10521-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 15:35:30 +0100
Message-ID: <1271428530.23489.3.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2010 14:35:34.0133 (UTC) FILETIME=[12964A50:01CADD72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Frederic,

Thanks for this.

On Tue, 2010-04-13 at 00:01 +0100, Frederic Weisbecker wrote:
> There are two outstanding fashions for archs to implement hardware
> breakpoints.
> 
> The first is to separate breakpoint address pattern definition
> space between data and instruction breakpoints. We then have
> typically distinct instruction address breakpoint registers
> and data address breakpoint registers, delivered with
> separate control registers for data and instruction breakpoints
> as well. This is the case of PowerPc and ARM for example.
> 
> The second consists in having merged breakpoint address space
> definition between data and instruction breakpoint. Address
> registers can host either instruction or data address and
> the access mode for the breakpoint is defined in a control
> register. This is the case of x86.
> 
> This patch adds a new CONFIG_HAVE_MIXED_BREAKPOINTS_REGS config
> that archs can select if they belong to the second case. Those
> will have their slot allocation merged for instructions and
> data breakpoints.
> 
> The others will have a separate slot tracking between data and
> instruction breakpoints.

This looks useful for supporting architectures with separate
data/instruction breakpoints.

A couple of points:

1.) Will this affect the arch backend at all?

2.) On ARM, it is possible to have different numbers of breakpoint registers
    and watchpoint registers [which we do not know until runtime]. This
    means that we have to define HBP_NUM as a potential upper bound,
    which seems a bit wasteful. Perhaps there could be a mechanism to 
    register the available resources at runtime?

Thanks,

Will



