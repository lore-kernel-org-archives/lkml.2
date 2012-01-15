Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2AOJ5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:57:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2AOJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:57:14 -0500
Message-ID: <4F12A2E4.6050304@redhat.com>
Date: Sun, 15 Jan 2012 11:56:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH] KVM: Fix MOVSX emulation
References: <1326566048-6756-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1326566048-6756-1-git-send-email-namit@cs.technion.ac.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 08:34 PM, Nadav Amit wrote:
> The destination register of MOVSX should be decoded similarily to MOVZX.
>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  arch/x86/kvm/emulate.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 05a562b..7644a83 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3553,7 +3553,8 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
>  	case OpReg:
>  		decode_register_operand(ctxt, op,
>  			 op == &ctxt->dst &&
> -			 ctxt->twobyte && (ctxt->b == 0xb6 || ctxt->b == 0xb7));
> +			 ctxt->twobyte && ((ctxt->b & 0xfe) == 0xb6 ||
> +				(ctxt->b & 0xfe) == 0xbe));
>  		break;
>  	case OpImmUByte:
>  		rc = decode_imm(ctxt, op, 1, false);

Please post a unit test for this.  See
git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git x86/emulate.c.

-- 
error compiling committee.c: too many arguments to function

