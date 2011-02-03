Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1BCRN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:13:56 -0500
Received: from service87.mimecast.com ([94.185.240.25]:45887 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755168Ab1BCRNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:13:55 -0500
Subject: Re: [PATCH v4 06/19] ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type
 definitions as u32
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295891761-18366-7-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-7-git-send-email-catalin.marinas@arm.com>
Organization: ARM Limited
Date: Thu, 03 Feb 2011 17:13:49 +0000
Message-ID: <1296753229.28466.20.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 03 Feb 2011 17:13:51.0266 (UTC) FILETIME=[BA5A8820:01CBC3C5]
X-MC-Unique: 111020317135301601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 17:55 +0000, Catalin Marinas wrote:
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -290,7 +290,7 @@ static void __init build_mem_type_table(void)
>  {
>         struct cachepolicy *cp;
>         unsigned int cr = get_cr();
> -       unsigned int user_pgprot, kern_pgprot, vecs_pgprot;
> +       pgprotval_t user_pgprot, kern_pgprot, vecs_pgprot;
>         int cpu_arch = cpu_architecture();
>         int i;

I have an additional hunk for this file as pmd's have are 64-bit long
with LPAE (fixup pushed to the arm-lpae branch):

@@ -62,7 +62,7 @@ EXPORT_SYMBOL(pgprot_kernel);
 struct cachepolicy {
 	const char	policy[16];
 	unsigned int	cr_mask;
-	unsigned int	pmd;
+	pmdval_t	pmd;
 	pteval_t	pte;
 }; 

-- 
Catalin


