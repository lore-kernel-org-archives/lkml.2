Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0C2OOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:14:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0C2OOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:14:21 -0400
Subject: Re: [PATCH 0/2] perf: Use LBR for machine/oops debugging
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
In-Reply-To: <87bpe7qnrg.fsf@basil.nowhere.org>
References: <20100329122021.765109681@chello.nl>
	 <87bpe7qnrg.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:14:19 +0200
Message-ID: <1269872059.12097.338.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 15:08 +0200, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > The LBRs are relatively cheap to keep enabled and provide some history
> > to OOPSen, also some CPUs are reported to keep them over soft-reset,
> > which allows us to use them to debug things like tripple faults.
> >
> > Therefore introduce a boot option: lbr_debug=on, which always enable
> > the LBRs and will print the LBRs on CPU init and die().
> 
> 
> die is too late. they will only contain the oops code then.

We do an lbr_off() in oops_begin(), or is there a better/earlier place
we can do that?

