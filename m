Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2BXUW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:22:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34329 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840Ab2BXUW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:22:27 -0500
Message-ID: <4F47F167.6070203@zytor.com>
Date: Fri, 24 Feb 2012 12:21:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86-64: improve insn scheduling in SAVE_ARGS_IRQ
References: <4F4788A50200007800074A26@nat28.tlf.novell.com>
In-Reply-To: <4F4788A50200007800074A26@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 03:55 AM, Jan Beulich wrote:
>  	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
> -	testl $3, CS(%rdi)
> +	testl $3, CS-RBP(%rsi)
>  	je 1f

IIRC there is no imm8 version of testl; could this be a testb instead or
is that going to cause stalls on some platforms you think?

	-hpa

