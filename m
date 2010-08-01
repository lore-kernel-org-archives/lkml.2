Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0HAIXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:23:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41708 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0HAIXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SjkjhRakAdsOKP2E7VQ59TA0bm3jHyB4WXvz3h4pCsHaP+FjJ+04Wr3XZgvax7xHfD
         1DjbBt11/T1rbYZKJMY4jXyBWUa+XBD0IKZRPpHP+LO0cT4NWrLLkZekTvl6l+iHueeX
         8SpqvO0eC+pC2c6SHYUCyjpojCVHLIHQOtY0c=
Date: Sun, 1 Aug 2010 11:23:03 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        nouveau@lists.freedesktop.org
Subject: Re: [PATCH] x86,mmiotrace: add support for tracing STOS instruction
Message-ID: <20100801112303.3e9bea3e@daedalus.pq.iki.fi>
In-Reply-To: <20100731205101.GA5860@joi.lan>
References: <20100731205101.GA5860@joi.lan>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010 22:51:01 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Pekka Paalanen <pq@iki.fi>

I have not checked the correctness of this patch, but otherwise:
Acked-by: Pekka Paalanen <pq@iki.fi>

> ---
>  arch/x86/mm/pf_in.c |   30 +++++++++++++++++-------------
>  1 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
> index 308e325..38e6d17 100644
> --- a/arch/x86/mm/pf_in.c
> +++ b/arch/x86/mm/pf_in.c
> @@ -40,16 +40,16 @@ static unsigned char prefix_codes[] = {
>  static unsigned int reg_rop[] = {
>  	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
>  };
> -static unsigned int reg_wop[] = { 0x88, 0x89 };
> +static unsigned int reg_wop[] = { 0x88, 0x89, 0xAA, 0xAB };
>  static unsigned int imm_wop[] = { 0xC6, 0xC7 };
>  /* IA32 Manual 3, 3-432*/
> -static unsigned int rw8[] = { 0x88, 0x8A, 0xC6 };
> +static unsigned int rw8[] = { 0x88, 0x8A, 0xC6, 0xAA };
>  static unsigned int rw32[] = {
> -	0x89, 0x8B, 0xC7, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
> +	0x89, 0x8B, 0xC7, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F, 0xAB
>  };
> -static unsigned int mw8[] = { 0x88, 0x8A, 0xC6, 0xB60F, 0xBE0F };
> +static unsigned int mw8[] = { 0x88, 0x8A, 0xC6, 0xB60F, 0xBE0F,
> 0xAA }; static unsigned int mw16[] = { 0xB70F, 0xBF0F };
> -static unsigned int mw32[] = { 0x89, 0x8B, 0xC7 };
> +static unsigned int mw32[] = { 0x89, 0x8B, 0xC7, 0xAB };
>  static unsigned int mw64[] = {};
>  #else /* not __i386__ */
>  static unsigned char prefix_codes[] = {
> @@ -63,20 +63,20 @@ static unsigned char prefix_codes[] = {
>  static unsigned int reg_rop[] = {
>  	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
>  };
> -static unsigned int reg_wop[] = { 0x88, 0x89 };
> +static unsigned int reg_wop[] = { 0x88, 0x89, 0xAA, 0xAB };
>  static unsigned int imm_wop[] = { 0xC6, 0xC7 };
> -static unsigned int rw8[] = { 0xC6, 0x88, 0x8A };
> +static unsigned int rw8[] = { 0xC6, 0x88, 0x8A, 0xAA };
>  static unsigned int rw32[] = {
> -	0xC7, 0x89, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
> +	0xC7, 0x89, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F, 0xAB
>  };
>  /* 8 bit only */
> -static unsigned int mw8[] = { 0xC6, 0x88, 0x8A, 0xB60F, 0xBE0F };
> +static unsigned int mw8[] = { 0xC6, 0x88, 0x8A, 0xB60F, 0xBE0F,
> 0xAA }; /* 16 bit only */
>  static unsigned int mw16[] = { 0xB70F, 0xBF0F };
>  /* 16 or 32 bit */
>  static unsigned int mw32[] = { 0xC7 };
>  /* 16, 32 or 64 bit */
> -static unsigned int mw64[] = { 0x89, 0x8B };
> +static unsigned int mw64[] = { 0x89, 0x8B, 0xAB };
>  #endif /* not __i386__ */
>  
>  struct prefix_bits {
> @@ -410,7 +410,6 @@ static unsigned long *get_reg_w32(int no,
> struct pt_regs *regs) unsigned long get_ins_reg_val(unsigned long
> ins_addr, struct pt_regs *regs) {
>  	unsigned int opcode;
> -	unsigned char mod_rm;
>  	int reg;
>  	unsigned char *p;
>  	struct prefix_bits prf;
> @@ -437,8 +436,13 @@ unsigned long get_ins_reg_val(unsigned long
> ins_addr, struct pt_regs *regs) goto err;
>  
>  do_work:
> -	mod_rm = *p;
> -	reg = ((mod_rm >> 3) & 0x7) | (prf.rexr << 3);
> +	/* for STOS, source register is fixed */
> +	if (opcode == 0xAA || opcode == 0xAB) {
> +		reg = arg_AX;
> +	} else {
> +		unsigned char mod_rm = *p;
> +		reg = ((mod_rm >> 3) & 0x7) | (prf.rexr << 3);
> +	}
>  	switch (get_ins_reg_width(ins_addr)) {
>  	case 1:
>  		return *get_reg_w8(reg, prf.rex, regs);
> -- 
> 1.7.1.1

-- 
Pekka Paalanen
http://www.iki.fi/pq/
