Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1FMXX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:23:58 -0400
Received: from mail.perches.com ([173.55.12.10]:2894 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1FMXX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:23:57 -0400
Subject: Re: two false alarms from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Jian Peng <jipeng@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874572DE7E95F@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874572DE7E95F@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 16:23:56 -0700
Message-ID: <1308007436.26699.57.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 16:18 -0700, Jian Peng wrote:
> After running "./scripts/checkpatch.pl -F arch/mips/kernel/syscall.c", I got some errors reported on valid lines
> 
> ERROR: space prohibited before open square bracket '['
> #451: FILE: mips/kernel/syscall.c:451:
> +		: [addr] "r" (addr),
> 
> This line is valid, and if I remove the space in between, it will report a different error
> 
> ERROR: spaces required around that ':' (ctx:ExV)
> #448: FILE: mips/kernel/syscall.c:448:
> +		:[old] "=&r" (old),
>  		^
> In another case, it reported

Known defect.  checkpatch doesn't correctly parse asm.
checkpatch output isn't dicta.
You should just ignore it.

> ERROR: trailing statements should be on next line
> #515: FILE: mips/kernel/syscall.c:515:
> +	while (1);
> 
> This is also valid line.

That's really not a kernel style conformant line.

It really should be written as something like:

	while (1) {
		;		/* Never exit */
	}

