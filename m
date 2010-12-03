Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0LCL1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:27:06 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37594 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab0LCL1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:27:03 -0500
Date: Fri, 3 Dec 2010 06:26:12 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Subject: Re: linux-next: build failure after merge of the final tree
	(powerpc tree related)
Message-ID: <20101203112612.GA4489@zod.rchland.ibm.com>
References: <20101203163206.72258fb8.sfr@canb.auug.org.au>
 <1291355998.32570.417.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291355998.32570.417.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 04:59:58PM +1100, Benjamin Herrenschmidt wrote:
>On Fri, 2010-12-03 at 16:32 +1100, Stephen Rothwell wrote:
>> 
>> After merging the  tree, today's linux-next build (powerpc allmodconfig)
>> failed like this:
>> 
>> arch/powerpc/lib/hweight_64.S: Assembler messages:
>> arch/powerpc/lib/hweight_64.S:52: Error: Unrecognized opcode: `popcntw'
>> arch/powerpc/lib/hweight_64.S:77: Error: Unrecognized opcode: `popcntw'
>> arch/powerpc/lib/hweight_64.S:106: Error: Unrecognized opcode: `popcntd'
>> 
>> This is with:
>> 
>> powerpc64-linux-gcc (GCC) 4.4.0
>> GNU assembler (GNU Binutils) 2.19.1
>> 
>> Caused by commit 64ff31287693c1f325cb9cb049569c1611438ef1 ("powerpc: Add
>> support for popcnt instructions"). 
>
>
>This toolchain is a bit ancient I suppose... Anton, do you reckon we

SLES 11 SP1 still uses gcc 4.3.  4.4.0 is not ancient by any means.  Neither is binutils 2.19.1.

>should use .long based macros for these for the time being or just
>require a newer binutils ?

.long macros sound like the proper solution.

josh
