Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab0HEIs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:48:28 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:56304 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab0HEIs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:48:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19546.31437.994840.466509@pilspetsen.it.uu.se>
Date: Thu, 5 Aug 2010 10:48:13 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: R_ARM_REL32 relocation support
In-Reply-To: <1280993763-15254-1-git-send-email-olof@lixom.net>
References: <34780qy39a4uj093a4y>
	<1280993763-15254-1-git-send-email-olof@lixom.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson writes:
 > commit d0679c730395d0bde9a46939e7ba255b4ba7dd7c moved -fno-dwarf2-cfi-asm to be
 > powerpc-only, causing R_ARM_REL32 to be used with some toolchains on ARM.
 > 
 > Implement support for it to make modules work with more toolchains.
 > 
 > Signed-off-by: Olof Johansson <olof@lixom.net>

Michal Marek's patch(*) to use -fno-dwarf2-cfi-asm already exists
and is IMO the correct solution in that it addresses the cause
of the problem rather than its symptoms.

NAK from me for now.

(*) http://lkml.org/lkml/2010/7/26/154

/Mikael

 > ---
 >  arch/arm/include/asm/elf.h |    1 +
 >  arch/arm/kernel/module.c   |    4 ++++
 >  2 files changed, 5 insertions(+), 0 deletions(-)
 > 
 > diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
 > index 51662fe..b1f1991 100644
 > --- a/arch/arm/include/asm/elf.h
 > +++ b/arch/arm/include/asm/elf.h
 > @@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 >  #define R_ARM_NONE		0
 >  #define R_ARM_PC24		1
 >  #define R_ARM_ABS32		2
 > +#define R_ARM_REL32		3
 >  #define R_ARM_CALL		28
 >  #define R_ARM_JUMP24		29
 >  #define R_ARM_V4BX		40
 > diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
 > index c628bdf..ec9526d 100644
 > --- a/arch/arm/kernel/module.c
 > +++ b/arch/arm/kernel/module.c
 > @@ -132,6 +132,10 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 >  			*(u32 *)loc += sym->st_value;
 >  			break;
 >  
 > +		case R_ARM_REL32:
 > +			*(u32 *)loc += sym->st_value - loc;
 > +			break;
 > +
 >  		case R_ARM_PC24:
 >  		case R_ARM_CALL:
 >  		case R_ARM_JUMP24:
 > -- 
 > 1.5.6.5
 > 
 > 
 > _______________________________________________
 > linux-arm-kernel mailing list
 > linux-arm-kernel@lists.infradead.org
 > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
 > 
