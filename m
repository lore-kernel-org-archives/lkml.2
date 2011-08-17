Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1HQUjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1HQUjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 19/36] Hexagon: Add ptrace support
Date: Wed, 17 Aug 2011 21:47:02 +0200
Message-ID: <2462338.kr2t1K64O5@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163521.637768691@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163521.637768691@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:StRmKiMFmHJW3KkwsLo4P+stkiaDWi2ZM74ptytSqFB
 3dSRcUDhIpwN8VIVcqY8D74j5xcalUeIeRdcmPJWFLnpH7tlmI
 e+XakofuSoYF8zB8qbyFarcLzZTCK/Ex5XgBEgtRLL/4H47v1F
 leH9wJg07IHjIzEsbh22yeRyGBQw1lgeilCVWIePs2OP/JU7bz
 +VGhVT96jf2bXdRj1yzNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:16 Richard Kuo wrote:
> +       switch (request) {
> +       case PTRACE_PEEKUSR:    /* read register specified by addr. */
> +               ret = ptrace_peekusr(child, addr, (void __user *) data);
> +               break;
> +       case PTRACE_POKETEXT:   /* write the word at location addr. */
> +       case PTRACE_POKEDATA:
> +               ret = generic_ptrace_pokedata(child, addr, data);
> +               break;
> +       case PTRACE_POKEUSR:    /* write register specified by addr. */
> +               ret = ptrace_pokeusr(child, addr, data);
> +               break;
> +       case PTRACE_GETREGS:
> +               ret = ptrace_getregs(child, (void __user *) data);
> +               break;
> +       case PTRACE_SETREGS:
> +               ret = ptrace_setregs(child, (void __user *) data);
> +               break;
> +       default:

I believe the current way to do this is to use regsets for everything,
see arch/openrisc/kernel/ptrace.c

	Arnd
