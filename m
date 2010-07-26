Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0GZF7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:59:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50577 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0GZF7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OZo8K9JnHp8qkn9UHkV+IsSlTrIC++me0vsnOntLRQbbYIsCnuPwDjvx0Z8Mzdlcqp
         xX+DSHWNaSV2NN3BZI8mp2XkmrcGSgQUUE0JFKdCCvN8VjIFKr+bXdLVU0i5cXe4l7IA
         jPEwsJgyYxVwfGKKnwFfJ0SMOcn4beycOEWNk=
MIME-Version: 1.0
In-Reply-To: <1280123724-23226-1-git-send-email-emjay1988@gmail.com>
References: <1280123724-23226-1-git-send-email-emjay1988@gmail.com>
Date: Mon, 26 Jul 2010 15:59:33 +1000
Message-ID: <AANLkTik9hs7H0qwW-AjLmQHwT+8mF52DR2=KQUGeHaYN@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: kvm: emulate.c: Fixed up all code-style ERRORs
From: Michael Jensen <emjay1988@gmail.com>
To: avi@redhat.com
Cc: mtosatti@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Jensen <emjay1988@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6Q5xk3v006842

There is no PATCH 2/2, it was merged in to this patch, but I missed
the subject line
when merging.

Patch 2 removed spaces before a tab.

On Mon, Jul 26, 2010 at 3:55 PM, Michael Jensen <emjay1988@gmail.com> wrote:
> Wrapped lines and fixed indentation throughout emulate.c, now
> passes checkpatch.pl with no ERRORs.
>
> Signed-off-by: Michael Jensen <emjay1988@gmail.com>
> ---
>  arch/x86/kvm/emulate.c |   66 +++++++++++++++++++++++++++++-------------------
>  1 files changed, 40 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5ac0bb4..2562ed8 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -457,29 +457,35 @@ static u32 group2_table[] = {
>
>
>  /* Raw emulation: instruction has two explicit operands. */
> -#define __emulate_2op_nobyte(_op,_src,_dst,_eflags,_wx,_wy,_lx,_ly,_qx,_qy) \
> +#define __emulate_2op_nobyte(_op, _src, _dst, _eflags,                 \
> +                            _wx, _wy, _lx, _ly, _qx, _qy)              \
>        do {                                                            \
>                unsigned long _tmp;                                     \
>                                                                        \
>                switch ((_dst).bytes) {                                 \
>                case 2:                                                 \
> -                       ____emulate_2op(_op,_src,_dst,_eflags,_wx,_wy,"w"); \
> +                       ____emulate_2op(_op, _src, _dst,                \
> +                                       _eflags, _wx, _wy, "w");        \
>                        break;                                          \
>                case 4:                                                 \
> -                       ____emulate_2op(_op,_src,_dst,_eflags,_lx,_ly,"l"); \
> +                       ____emulate_2op(_op, _src, _dst,                \
> +                                       _eflags, _lx, _ly, "l");        \
>                        break;                                          \
>                case 8:                                                 \
> -                       ON64(____emulate_2op(_op,_src,_dst,_eflags,_qx,_qy,"q")); \
> +                       ON64(____emulate_2op(_op, _src, _dst,           \
> +                                            _eflags, _qx, _qy, "q"));  \
>                        break;                                          \
>                }                                                       \
>        } while (0)
>
> -#define __emulate_2op(_op,_src,_dst,_eflags,_bx,_by,_wx,_wy,_lx,_ly,_qx,_qy) \
> +#define __emulate_2op(_op, _src, _dst, _eflags,                                     \
> +                     _bx, _by, _wx, _wy, _lx, _ly, _qx, _qy)                \
>        do {                                                                 \
>                unsigned long _tmp;                                          \
>                switch ((_dst).bytes) {                                      \
>                case 1:                                                      \
> -                       ____emulate_2op(_op,_src,_dst,_eflags,_bx,_by,"b");  \
> +                       ____emulate_2op(_op, _src, _dst,                     \
> +                                       _eflags, _bx, _by, "b");             \
>                        break;                                               \
>                default:                                                     \
>                        __emulate_2op_nobyte(_op, _src, _dst, _eflags,       \
> @@ -556,13 +562,21 @@ static u32 group2_table[] = {
>        } while (0)
>
>  /* Instruction has only one explicit operand (no source operand). */
> -#define emulate_1op(_op, _dst, _eflags)                                    \
> +#define emulate_1op(_op, _dst, _eflags)                                 \
>        do {                                                            \
>                switch ((_dst).bytes) {                                 \
> -               case 1: __emulate_1op(_op, _dst, _eflags, "b"); break;  \
> -               case 2: __emulate_1op(_op, _dst, _eflags, "w"); break;  \
> -               case 4: __emulate_1op(_op, _dst, _eflags, "l"); break;  \
> -               case 8: ON64(__emulate_1op(_op, _dst, _eflags, "q")); break; \
> +               case 1:                                                 \
> +                       __emulate_1op(_op, _dst, _eflags, "b");         \
> +                       break;                                          \
> +               case 2:                                                 \
> +                       __emulate_1op(_op, _dst, _eflags, "w");         \
> +                       break;                                          \
> +               case 4:                                                 \
> +                       __emulate_1op(_op, _dst, _eflags, "l");         \
> +                       break;                                          \
> +               case 8:                                                 \
> +                       ON64(__emulate_1op(_op, _dst, _eflags, "q"));   \
> +                       break;                                          \
>                }                                                       \
>        } while (0)
>
> @@ -749,7 +763,7 @@ static int test_cc(unsigned int condition, unsigned int flags)
>        }
>
>        /* Odd condition identifiers (lsb == 1) have inverted sense. */
> -       return (!!rc ^ (condition & 1));
> +       return !!rc ^ (condition & 1);
>  }
>
>  static void decode_register_operand(struct operand *op,
> @@ -1234,18 +1248,18 @@ done_prefixes:
>                c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
>                c->dst.ptr = &c->regs[VCPU_REGS_RAX];
>                switch (c->dst.bytes) {
> -                       case 1:
> -                               c->dst.val = *(u8 *)c->dst.ptr;
> -                               break;
> -                       case 2:
> -                               c->dst.val = *(u16 *)c->dst.ptr;
> -                               break;
> -                       case 4:
> -                               c->dst.val = *(u32 *)c->dst.ptr;
> -                               break;
> -                       case 8:
> -                               c->dst.val = *(u64 *)c->dst.ptr;
> -                               break;
> +               case 1:
> +                       c->dst.val = *(u8 *)c->dst.ptr;
> +                       break;
> +               case 2:
> +                       c->dst.val = *(u16 *)c->dst.ptr;
> +                       break;
> +               case 4:
> +                       c->dst.val = *(u32 *)c->dst.ptr;
> +                       break;
> +               case 8:
> +                       c->dst.val = *(u64 *)c->dst.ptr;
> +                       break;
>                }
>                c->dst.orig_val = c->dst.val;
>                break;
> @@ -1306,7 +1320,7 @@ static void get_descriptor_table_ptr(struct x86_emulate_ctxt *ctxt,
>  {
>        if (selector & 1 << 2) {
>                struct desc_struct desc;
> -               memset (dt, 0, sizeof *dt);
> +               memset(dt, 0, sizeof *dt);
>                if (!ops->get_cached_descriptor(&desc, VCPU_SREG_LDTR, ctxt->vcpu))
>                        return;
>
> @@ -1530,7 +1544,7 @@ static int emulate_popf(struct x86_emulate_ctxt *ctxt,
>        change_mask = EFLG_CF | EFLG_PF | EFLG_AF | EFLG_ZF | EFLG_SF | EFLG_OF
>                | EFLG_TF | EFLG_DF | EFLG_NT | EFLG_RF | EFLG_AC | EFLG_ID;
>
> -       switch(ctxt->mode) {
> +       switch (ctxt->mode) {
>        case X86EMUL_MODE_PROT64:
>        case X86EMUL_MODE_PROT32:
>        case X86EMUL_MODE_PROT16:
> --
> 1.7.0.4
>
>



-- 
Regards,

Michael Jensen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
