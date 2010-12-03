Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0LCGAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:00:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:57845 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0LCGAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:00:15 -0500
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>
In-Reply-To: <20101203163206.72258fb8.sfr@canb.auug.org.au>
References: <20101203163206.72258fb8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 16:59:58 +1100
Message-ID: <1291355998.32570.417.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 16:32 +1100, Stephen Rothwell wrote:
> 
> After merging the  tree, today's linux-next build (powerpc allmodconfig)
> failed like this:
> 
> arch/powerpc/lib/hweight_64.S: Assembler messages:
> arch/powerpc/lib/hweight_64.S:52: Error: Unrecognized opcode: `popcntw'
> arch/powerpc/lib/hweight_64.S:77: Error: Unrecognized opcode: `popcntw'
> arch/powerpc/lib/hweight_64.S:106: Error: Unrecognized opcode: `popcntd'
> 
> This is with:
> 
> powerpc64-linux-gcc (GCC) 4.4.0
> GNU assembler (GNU Binutils) 2.19.1
> 
> Caused by commit 64ff31287693c1f325cb9cb049569c1611438ef1 ("powerpc: Add
> support for popcnt instructions"). 


This toolchain is a bit ancient I suppose... Anton, do you reckon we
should use .long based macros for these for the time being or just
require a newer binutils ?

Cheers,
Ben.


