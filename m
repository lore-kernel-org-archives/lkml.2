Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2D2IW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 04:22:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2D2IWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 04:22:54 -0400
Date: Sun, 29 Apr 2012 11:22:33 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: avi@redhat.com, mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] KVM: Emulator: Opcode 0x80 gets a byte immediate
Message-ID: <20120429082233.GX15413@redhat.com>
References: <1335536616-8524-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335536616-8524-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 05:23:36PM +0300, Nadav Amit wrote:
> The single byte opcode 0x80 should get a byte immediate.
> The previous emulation is broken for opcode 0x80.
It is not. That what ByteOp is about.

> ---
>  arch/x86/kvm/emulate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 8375622..dd53e53 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3464,7 +3464,7 @@ static struct opcode opcode_table[256] = {
>  	/* 0x70 - 0x7F */
>  	X16(D(SrcImmByte)),
>  	/* 0x80 - 0x87 */
> -	G(ByteOp | DstMem | SrcImm | ModRM | Group, group1),
> +	G(ByteOp | DstMem | SrcImmByte | ModRM | Group, group1),
>  	G(DstMem | SrcImm | ModRM | Group, group1),
>  	G(ByteOp | DstMem | SrcImm | ModRM | No64 | Group, group1),
>  	G(DstMem | SrcImmByte | ModRM | Group, group1),
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
