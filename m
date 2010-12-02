Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab0LBONF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:13:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46489 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab0LBONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:13:04 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=Uee2h3AocgwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=i6KQcvlBe_fW_U8rxRkA:9 a=rgN7zarBYaUTnOA_oskA:7 a=2TsocmuCaxFm_wk7E_QQ1kViWFoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] scripts/tags.sh: Add magic for trace-events
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1290591835.2072.438.camel@laptop>
References: <1290591835.2072.438.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Dec 2010 09:13:01 -0500
Message-ID: <1291299181.12005.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 10:43 +0100, Peter Zijlstra wrote:
> Make tags find the trace-event definitions
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Should we push this patch for 2.6.37? It's small, useful, and does not
impact the kernel whatsoever. But can we call this a bug fix?

-- Steve

> ---
>  scripts/tags.sh |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 8509bb5..bbbe584 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -125,7 +125,9 @@ exuberant()
>  	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
>  	--extra=+f --c-kinds=-px                                \
>  	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
> -	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
> +	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
> +	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
> +	--regex-c++='/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'
>  
>  	all_kconfigs | xargs $1 -a                              \
>  	--langdef=kconfig --language-force=kconfig              \


