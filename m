Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab2LSGPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:15:13 -0500
Received: from ozlabs.org ([203.10.76.45]:60840 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2LSGPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:15:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: manual merge of the modules tree with Linus' tree
In-Reply-To: <20121219111053.345900e0b35ee8f4def990a7@canb.auug.org.au>
References: <20121219111053.345900e0b35ee8f4def990a7@canb.auug.org.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 19 Dec 2012 16:08:08 +1030
Message-ID: <87txri1u0v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> Today's linux-next merge of the modules tree got a conflict in
> kernel/modsign_pubkey.c between commit 84ecfd15f554 ("modsign: add symbol
> prefix to certificate list") from Linus' tree and commit bb8f5966421d
> ("MODSIGN: Avoid using .incbin in C source") from the modules tree.

Gah, I had a brainfart reading gitk and thought commit was not upstream
:(

(Paul Mackerras points out that gitk shows you what branches a commit is
in, so I now have no excuse.  He also offered to colour-code it for me
RSN, which would make it inescapable).

> I fixed it up (I just used the modules tree version as it removed the
> section of code modified by the former) and can carry the fix as
> necessary (no action is required).

Yes, but that leaves this turd in linux/kernel.h from
cbdbf2abb7844548a7d7a6a2ae7af6b6fbcea401:

+/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
+#ifdef CONFIG_SYMBOL_PREFIX
+#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define SYMBOL_PREFIX ""
+#endif

I have reverted to the previous modules-next.

Thanks,
Rusty.
