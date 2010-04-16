Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0DPO4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:56:13 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:58464 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0DPO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HIIwTVTazpiUbPwCW3FfmHI117OiLwCtXhJDS3CQtjJq0azLokGZKn1VqENqq2FfF5
         93815p+jBpxjaF99gc6D1B2prq+0TqUU9sImirun2tEwsFxCgTPFH4zwX6QrVr21k/zW
         nTSykt5L4FDKsrPRNOehoh+vds+Ug79dd9MZY=
Date: Fri, 16 Apr 2010 16:56:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 1/2] hw-breakpoints: Separate constraint space for
	data and instruction breakpoints
Message-ID: <20100416145607.GD5162@nowhere>
References: <1271113280-10521-1-git-send-regression-fweisbec@gmail.com> <1271113280-10521-2-git-send-regression-fweisbec@gmail.com> <1271428530.23489.3.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271428530.23489.3.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:35:30PM +0100, Will Deacon wrote:
> Hello Frederic,
> 
> Thanks for this.
> 
> On Tue, 2010-04-13 at 00:01 +0100, Frederic Weisbecker wrote:
> > There are two outstanding fashions for archs to implement hardware
> > breakpoints.
> > 
> > The first is to separate breakpoint address pattern definition
> > space between data and instruction breakpoints. We then have
> > typically distinct instruction address breakpoint registers
> > and data address breakpoint registers, delivered with
> > separate control registers for data and instruction breakpoints
> > as well. This is the case of PowerPc and ARM for example.
> > 
> > The second consists in having merged breakpoint address space
> > definition between data and instruction breakpoint. Address
> > registers can host either instruction or data address and
> > the access mode for the breakpoint is defined in a control
> > register. This is the case of x86.
> > 
> > This patch adds a new CONFIG_HAVE_MIXED_BREAKPOINTS_REGS config
> > that archs can select if they belong to the second case. Those
> > will have their slot allocation merged for instructions and
> > data breakpoints.
> > 
> > The others will have a separate slot tracking between data and
> > instruction breakpoints.
> 
> This looks useful for supporting architectures with separate
> data/instruction breakpoints.
> 
> A couple of points:
> 
> 1.) Will this affect the arch backend at all?


No change is required from the backend. In fact this config probably
only fits for x86, unless there are other archs that have shared
register addresses... Archs that only support data or inst breakpoints
should also select it, but only to save a bit of memory, there would
be no functional changes.


 
> 2.) On ARM, it is possible to have different numbers of breakpoint registers
>     and watchpoint registers [which we do not know until runtime]. This
>     means that we have to define HBP_NUM as a potential upper bound,
>     which seems a bit wasteful. Perhaps there could be a mechanism to 
>     register the available resources at runtime?


Ah that's interesting. Ok, I will update my patch to integrate that.

