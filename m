Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1CJUB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:01:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1CJUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:01:55 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=chZ5b7rXJJhexNIG1YIA:9 a=2qbfdkoQB5ZdjiKCLQQA:7 a=rgY5vPA-SvrK0s-HhL4fBLQrePkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20110310195343.GA4058@redhat.com>
References: <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <4D790A13.4060705@caviumnetworks.com>
	 <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
	 <1299782143.15854.402.camel@gandalf.stny.rr.com>
	 <4D791CAA.7090108@caviumnetworks.com>
	 <1299783236.15854.405.camel@gandalf.stny.rr.com>
	 <4D791F31.6040100@caviumnetworks.com>
	 <1299785143.15854.407.camel@gandalf.stny.rr.com>
	 <1299786329.15854.409.camel@gandalf.stny.rr.com>
	 <20110310195343.GA4058@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 15:01:53 -0500
Message-ID: <1299787313.15854.411.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 14:53 -0500, Jason Baron wrote:

> agreed. something like the following is all that's needed for x86. Sparc
> already has this, so mips just needs something similar. Steve, should I
> re-post the entire series. Or can I just post this patch separately?

Nah, I could take this as a PATCH 3/2. Just reply with your SoB.

I still want to analyze the rest of the patch set. I've been doing busy
work for now. I'll do that this afternoon.

Thanks,

-- Steve

> 
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index f217cee..57f31ff 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -8,6 +8,7 @@
>  #include <asm/asm.h>
>  
>  #define JUMP_LABEL_NOP_SIZE 5
> +#define BYTES_PER_LONG (BITS_PER_LONG / 8)
>  
>  #define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
>  
> @@ -16,9 +17,10 @@ static __always_inline bool arch_static_branch(struct jump_label_key *key)
>  	asm goto("1:"
>  		JUMP_LABEL_INITIAL_NOP
>  		".pushsection __jump_table,  \"aw\" \n\t"
> -		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> +		".align %c0\n\t"
> +		_ASM_PTR "1b, %l[l_yes], %c1 \n\t"
>  		".popsection \n\t"
> -		: :  "i" (key) : : l_yes);
> +		: : "i" BYTES_PER_LONG, "i" (key) : : l_yes);
>  	return false;
>  l_yes:
>  	return true;


