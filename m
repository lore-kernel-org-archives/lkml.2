Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0HCUyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:54:41 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:53482 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab0HCUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:54:40 -0400
Date: Tue, 3 Aug 2010 21:54:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
cc: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        hschauhan@nulltrace.org
Subject: Re: [PATCH 2/5] MIPS: Add instrunction format for BREAK and
 SYSCALL
In-Reply-To: <1280859742-26364-3-git-send-email-ddaney@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1008032150060.20999@eddie.linux-mips.org>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com> <1280859742-26364-3-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, David Daney wrote:

> diff --git a/arch/mips/include/asm/inst.h b/arch/mips/include/asm/inst.h
> index 6489f00..444ff71 100644
> --- a/arch/mips/include/asm/inst.h
> +++ b/arch/mips/include/asm/inst.h
> @@ -247,6 +247,12 @@ struct ma_format {	/* FPU multipy and add format (MIPS IV) */
>  	unsigned int fmt : 2;
>  };
>  
> +struct b_format { /* BREAK and SYSCALL */
> +	unsigned int opcode:6;
> +	unsigned int code:20;
> +	unsigned int func:6;
> +};
> +
>  #elif defined(__MIPSEL__)
>  
>  struct j_format {	/* Jump format */

 Please note the code field of the BREAK instruction is by toolchain 
convention (bug-compatibility with the original MIPS assembler or 
suchlike) treated as a pair of swapped 10-bit fields -- you may want to 
double-check consistency of interpretation with usage elsewhere.

  Maciej
