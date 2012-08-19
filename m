Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2HSPBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:01:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58299 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2HSPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:01:47 -0400
Date: Sun, 19 Aug 2012 17:01:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, akpm@linux-foundation.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 55/74] lto, workaround: Add workaround for initcall reordering
Message-ID: <20120819150140.GP11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-56-git-send-email-andi@firstfloor.org> <5030B5DC020000780008A226@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030B5DC020000780008A226@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 09:46:04AM +0100, Jan Beulich wrote:
> >>> Andi Kleen <andi@firstfloor.org> 08/19/12 5:05 AM >>>
> >Work around a LTO gcc problem: when there is no reference to a variable
> >in a module it will be moved to the end of the program. This causes
> >reordering of initcalls which the kernel does not like.
> >Add a dummy reference function to avoid this. The function is
> >deleted by the linker.
> 
> This is not even true on x86, not to speak of generally.

Why is it not true ? 

__initcall is only defined for !MODULE and there __exit discards.

> 
> >+#ifdef CONFIG_LTO
> >+/* Work around a LTO gcc problem: when there is no reference to a variable
> >+ * in a module it will be moved to the end of the program. This causes
> >+ * reordering of initcalls which the kernel does not like.
> >+ * Add a dummy reference function to avoid this. The function is 
> >+ * deleted by the linker.
> >+ */
> >+#define LTO_REFERENCE_INITCALL(x) \
> >+    ; /* yes this is needed */            \
> >+    static __used __exit void *reference_##x(void)     \
> 
> Why not put it into e.g. section .discard.text? That could be expected to be
> discarded by the linker without being arch dependent, as long as all arches
> use DISCARDS in their linker script.


That's what __exit does, doesn't it?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
