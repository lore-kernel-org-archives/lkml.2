Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2B0ILs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:11:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:16290 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2B0ILr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 27 Feb 2012 03:11:47 -0500
Message-Id: <4F4B48CC0200007800074DD7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 27 Feb 2012 08:11:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, resend] x86-64: improve insn scheduling in
 SAVE_ARGS_IRQ
References: <4F4788A50200007800074A26@nat28.tlf.novell.com>
 <4F47F167.6070203@zytor.com>
In-Reply-To: <4F47F167.6070203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.02.12 at 21:21, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 02/24/2012 03:55 AM, Jan Beulich wrote:
>>  	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
>> -	testl $3, CS(%rdi)
>> +	testl $3, CS-RBP(%rsi)
>>  	je 1f
> 
> IIRC there is no imm8 version of testl; could this be a testb instead or
> is that going to cause stalls on some platforms you think?

As far as I'm aware, memory operations don't suffer "partial register
stalls" or alike, so yes, using a testb here ought to be appropriate.

Jan

