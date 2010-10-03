Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0JCOo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 10:44:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35217 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0JCOo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 10:44:27 -0400
Message-ID: <4CA89681.8000202@zytor.com>
Date: Sun, 03 Oct 2010 07:43:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: NOPL on 32-bit
References: <20101003093701.GB3733@liondog.tnic>
In-Reply-To: <20101003093701.GB3733@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2010 02:37 AM, Borislav Petkov wrote:
> Hi,
> 
> it looks like we currently clear X86_FEATURE_NOPL in detect_nopl()
> unconditionally and not only on 32-bit, as it should be according to
> ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8.
> 
> I'm thinking maybe something like the following might be in order
> 
> --
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index caa967d..9a2cfeb 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -713,7 +713,9 @@ void __init early_cpu_init(void)
>   */
>  static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
>  {
> +#ifdef CONFIG_X86_32
>  	clear_cpu_cap(c, X86_FEATURE_NOPL);
> +#endif
>  }
>  
>  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
> --
> 

Yes, that's a bug.  It should be disabled only on 32 bits.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

