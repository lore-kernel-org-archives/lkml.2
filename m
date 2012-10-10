Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab2JJN6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:58:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49434 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab2JJN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:58:06 -0400
Date: Wed, 10 Oct 2012 15:58:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: Improve 64 bit __phys_addr call performance
Message-ID: <20121010135801.GW16230@one.firstfloor.org>
References: <20121009185057.15478.86075.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009185057.15478.86075.stgit@gitlad.jf.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The second change was to streamline the code by making use of the carry flag
> on an add operation instead of performing a compare on a 64 bit value.  The
> advantage to this is that it allows us to reduce the overall size of the call.
> On my Xeon E5 system the entire __phys_addr inline call consumes 30 bytes and
> 5 instructions.  I also applied similar logic to the debug version of the
> function.  My testing shows that the debug version of the function with this
> patch applied is slightly faster than the non-debug version without the patch.

Looks good. Thanks. 

Probably should still split the callers though (or have a pa_symbol_fast
that does not do the check)

-Andi
