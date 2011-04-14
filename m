Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab1DNSLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933706Ab1DNSLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:11:32 -0400
Date: Thu, 14 Apr 2011 20:09:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] asm-generic/ptrace.h: start a common low level
	ptrace helper
Message-ID: <20110414180936.GA20924@redhat.com>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-2-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302760895-13459-2-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Mike Frysinger wrote:
>
> This implements a bunch of helper funcs for poking the registers of a
> ptrace structure.  Now common code should be able to portably update
> specific registers (like kgdb updating the PC).

The whole series looks correct, but I am a bit confused...

> +#ifndef GET_IP
> +#define GET_IP(regs) ((regs)->pc)
> +#endif

Could you explain this ifndef ?

IIUC, this should be included by arch/*/asm/ptrace.h. Isn't it better
to simply require that if you include asm-generic/ptrace.h you should
provide the necessary GET_* macros?

(regs)->pc looks a bit strange in asm-generic. But please feel free
to ignore.

Oleg.

