Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2JUPTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:19:33 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37259 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2JUPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:19:31 -0400
Date: Sun, 21 Oct 2012 18:19:24 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Borislav Petkov <bp@alien8.de>
cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [PATCH] tools/kvm: Add a .s file rule
In-Reply-To: <1350757194-14498-1-git-send-email-bp@alien8.de>
Message-ID: <alpine.LFD.2.02.1210211819130.1965@tux.localdomain>
References: <1350757194-14498-1-git-send-email-bp@alien8.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2012, Borislav Petkov wrote:
> Add a rule to the kvm tool Makefile to build .asm versions of the files.
> This is good for debugging purposes.
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> Cc: Asias He <asias.hejun@gmail.com>
> Signed-off-by: Borislav Petkov <bp@alien8.de>

Applied, thanks Borislav!

> ---
>  tools/kvm/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
> index 903001e80951..64f2646e5966 100644
> --- a/tools/kvm/Makefile
> +++ b/tools/kvm/Makefile
> @@ -314,6 +314,9 @@ util/rbtree.d: ../../lib/rbtree.c
>  %.d: %.c
>  	$(Q) $(CC) -M -MT $(patsubst %.d,%.o,$@) $(CFLAGS) $< -o $@
>  
> +%.s: %.c
> +	$(Q) $(CC) -o $@ -S $(CFLAGS) -fverbose-asm $<
> +
>  # The header file common-cmds.h is needed for compilation of builtin-help.c.
>  builtin-help.d: $(KVM_INCLUDE)/common-cmds.h
>  
> -- 
> 1.8.0.rc2
> 
> 
