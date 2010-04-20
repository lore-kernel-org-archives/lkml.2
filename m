Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0DTIhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:37:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52923 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0DTIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ii9JJVhwq6myCZTRvggMHZ92IL0g4GdXduXMKVAGmxoYXby27RPuFB8QaWWNhT/cyz
         pdlQa0KydXHnacd/yiVE13Nj1hQpypuJnnFCIMl7asNUcuicF2wn2w0x9pCa2lno573t
         oducSWUpCXQA66Y0LisocOYdrF1t/7ejF2a/k=
Date: Tue, 20 Apr 2010 16:33:58 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 2/5] uml: Drop private round_down definition
Message-ID: <20100420083358.GD4356@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <74c7d668690f283cf3b8aed92004dc72e872f7ce.1271713955.git.jan.kiszka@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74c7d668690f283cf3b8aed92004dc72e872f7ce.1271713955.git.jan.kiszka@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:53:05PM +0200, Jan Kiszka wrote:
>Already defined in kernel.h. The official version assumes that 'n' is
>power of two - which it is in our case.
>
>Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>---
> arch/um/sys-x86_64/signal.c |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
>
>diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
>index 1a899a7..07797d1 100644
>--- a/arch/um/sys-x86_64/signal.c
>+++ b/arch/um/sys-x86_64/signal.c
>@@ -165,8 +165,6 @@ struct rt_sigframe
> 	struct _fpstate fpstate;
> };
> 
>-#define round_down(m, n) (((m) / (n)) * (n))
>-
> int setup_signal_stack_si(unsigned long stack_top, int sig,
> 			  struct k_sigaction *ka, struct pt_regs * regs,
> 			  siginfo_t *info, sigset_t *set)

Shouldn't this signal.c #include <linux/kernel.h>?

Thanks.
