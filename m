Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2E3Q0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:26:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48262 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2E3Q0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:26:46 -0400
Date: Wed, 30 May 2012 18:26:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
Message-ID: <20120530162645.GT27374@one.firstfloor.org>
References: <20120527145112.GF17705@kronos.redsun> <m2396il7xc.fsf@firstfloor.org> <20120530113651.GP17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530113651.GP17705@kronos.redsun>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 01:36:51PM +0200, Johannes Goetzfried wrote:
> On Tue, May 29, 2012 at 07:27:43PM -0700, Andi Kleen wrote:
> > Also drivers should never print anything when they cannot find hardware.
> > Remove that printk.
> 
> I tried to be consistent with the existing ciphers in arch/x86/crypto.
> In serpent_sse2_glue.c and sha1_ssse3_glue.c it is done exactly that way, so if
> it will be decided to remove the printk in this patch it probably should also
> be removed in the other modules.


They are wrong and need to be fixed.

Drivers can be loaded for all kinds of reasons, but they are not supposed
to spam your kernel log when they do nothing.

In fact I fixed all the existing ones with the cpuid changes, unfortunately
somehow snuck in wrong code :-(

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
