Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672Ab0FQTGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:06:10 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:41402 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759992Ab0FQTGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:06:09 -0400
Date: Thu, 17 Jun 2010 21:04:56 +0200
From: Jesper Nilsson <jesper@jni.nu>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: MIPS: return after handling coprocessor 2 exception
Message-ID: <20100617190456.GC24162@jni.nu>
References: <20100617132554.GB24162@jni.nu> <4C1A57AE.9080706@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1A57AE.9080706@caviumnetworks.com>
User-Agent: Mutt/1.4.2.3i
X-Originating-IP: 83.249.211.213
X-Scan-Result: No virus found in message 1OPKOc-0006Gb-Cb.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OPKOc-0006Gb-Cb 09b7bac309e92e6f7a3833d0165c7858
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:13:18AM -0700, David Daney wrote:
> On 06/17/2010 06:25 AM, Jesper Nilsson wrote:
> >Breaking here dropped us to the default code which always sends
> >a SIGILL to the current process, no matter what the CU2 notifier says.
> >
> >Signed-off-by: Jesper Nilsson<jesper@jni.nu>
> >---
> >  traps.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> >index 8bdd6a6..8527808 100644
> >--- a/arch/mips/kernel/traps.c
> >+++ b/arch/mips/kernel/traps.c
> >@@ -976,7 +976,7 @@ asmlinkage void do_cpu(struct pt_regs *regs)
> >
> >  	case 2:
> >  		raw_notifier_call_chain(&cu2_chain, CU2_EXCEPTION, regs);
> >-		break;
> >+		return;
> >
> 
> What happens when the call chain is empty, and the proper action *is* 
> SIGILL?

Well, since there is a default notifier installed at the end, it will
correctly return SIGILL.

See the definition of default_cu2_call in the same file.

> David Daney

/^JN - Jesper Nilsson
--
                  Jesper Nilsson -- jesper_at_jni.nu
