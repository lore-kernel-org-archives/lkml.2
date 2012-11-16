Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2KPWVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:21:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2KPWU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:20:59 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Xsuh4gBeN78A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=DsRlZD7jQlIA:10 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=Ddi5EwL5P3mSx_b4FIAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353104456.7586.27.camel@gandalf.local.home>
Subject: Re: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on C
 visible symbols
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 17:20:56 -0500
In-Reply-To: <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
	 <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 13:57 -0800, Alexander Duyck wrote:
> Instead of using __pa which is meant to be a general function for converting
> virtual addresses to physical addresses we can use __pa_symbol which is the
> preferred way of decoding kernel text virtual addresses to physical addresses.
> 
> In this case we are not directly converting C visible symbols however if we
> know that the instruction pointer is somewhere between _text and _etext we
> know that we are going to be translating an address form the kernel text
> space.

Can I ask what the purpose of this is? I'm a little skeptical of a
change that is just "the preferred way".

Was there some bug that this fixes?

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
>  arch/x86/kernel/ftrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 1d41402..42a392a 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -89,7 +89,7 @@ do_ftrace_mod_code(unsigned long ip, const void *new_code)
>  	 * kernel identity mapping to modify code.
>  	 */
>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> -		ip = (unsigned long)__va(__pa(ip));
> +		ip = (unsigned long)__va(__pa_symbol(ip));
>  
>  	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
>  }
> @@ -279,7 +279,7 @@ static int ftrace_write(unsigned long ip, const char *val, int size)
>  	 * kernel identity mapping to modify code.
>  	 */
>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> -		ip = (unsigned long)__va(__pa(ip));
> +		ip = (unsigned long)__va(__pa_symbol(ip));
>  
>  	return probe_kernel_write((void *)ip, val, size);
>  }


