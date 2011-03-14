Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1CNWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:51:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52859 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1CNWvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:51:20 -0400
Message-ID: <4D7E9BCC.5070204@zytor.com>
Date: Mon, 14 Mar 2011 15:50:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jesper Juhl <jj@chaosbits.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][rfc] Use int as return type of main in arch/x86/boot/main.c
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net> <20110314190317.GA20259@home.goodmis.org>
In-Reply-To: <20110314190317.GA20259@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 12:03 PM, Steven Rostedt wrote:
> On Sun, Mar 13, 2011 at 11:00:09PM +0100, Jesper Juhl wrote:
>> I believe the return type of main should always be 'int'.
> 
> But this is not userspace, it is called from assmebly in header.S:
> 
>  # Jump to C code (should not return)
>  calll	main
> 
> We don't care what main returns. If it does return anything, then it
> dies:
> 
> # Setup corrupt somehow...
> setup_bad:
>         movl    $setup_corrupt, %eax
>         calll   puts
>         # Fall through...
> 
>         .globl  die
>         .type   die, @function
> die:
>         hlt
>         jmp     die
> 

Yes, but some versions of gcc complains about a nonstandard signature to
main().  At least that's what I assume Jesper's issue was.

	-hpa
