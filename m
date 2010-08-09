Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0HIHWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:22:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53486 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0HIHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:22:29 -0400
Date: Mon, 9 Aug 2010 09:22:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
Message-ID: <20100809072226.GD29524@basil.fritz.box>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
 <87k4o08fv9.fsf@basil.nowhere.org>
 <1281336031.976.11.camel@leonhard>
 <20100809064441.GC29524@basil.fritz.box>
 <1281337485.976.24.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281337485.976.24.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 04:04:45PM +0900, Namhyung Kim wrote:
> > It hides the value conversion from the compiler through asm()
> > 
> > -Andi
> > 
> 
> Yes, indeed. But for what? __pa_symbol() is just used to get the address
> of some linker symbols in forms of unsigned long which has same bit
> representation as pointer in x86 (and all supported archs). So do we
> still need it or am I missing something?

The original reason was that the C standard allows the compiler
to make some assumptions on the pointer arithmetic that is done 
on symbol addresses (e.g. no wrapping). This is exploited
by the optimizer in the compiler to generate better code.

This lead to a miscompilation on PowerPC a couple of years back at 
least with the va->pa conversion.

After that RELOC_HIDE was introduced after funelling the
symbol address through an empty asm statement was recommended 
as the official way to do this by the gcc developers.

I think x86-64 does not normally wrap here, but it's 
still safer to do it this way.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
