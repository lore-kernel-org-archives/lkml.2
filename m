Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab2GJM7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:59:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2GJM7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:59:00 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=j37N9Dys9Y4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=18O0u5j_zHS3M1rr4Y4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341925136.14828.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/8] tracing/function: Introduce persistent trace option
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Tue, 10 Jul 2012 08:58:56 -0400
In-Reply-To: <1341879046-5197-4-git-send-email-anton.vorontsov@linaro.org>
References: <20120710001004.GA22744@lizard>
	 <1341879046-5197-4-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 17:10 -0700, Anton Vorontsov wrote:

> +static struct tracer_flags func_flags;
> +
>  static void
>  function_trace_call(unsigned long ip, unsigned long parent_ip)
>  {
> @@ -97,6 +106,12 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
>  	disabled = atomic_inc_return(&data->disabled);
>  
>  	if (likely(disabled == 1)) {
> +		/*
> +		 * So far tracing doesn't support multiple buffers, so
> +		 * we make an explicit call for now.

I'm working on it ;-)

-- Steve

> +		 */
> +		if (unlikely(func_flags.val & TRACE_FUNC_OPT_PSTORE))
> +			pstore_ftrace_call(ip, parent_ip);
>  		pc = preempt_count();
>  		trace_function(tr, ip, parent_ip, flags, pc);
>  	}


