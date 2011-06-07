Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab1FGSIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:08:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61711 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1FGSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eVeCRQGq7bwz1MpjoBCkAnB+/v19/+1wizLW8HBn+SnF+mAvqqStkQO7Lc/ftEeKW9
         o4LaRqtGLzzShZGwlYhiilA/BiMKFj+x/2/6mwCluJWVCPvSyQFf5G14W33neK804lkF
         QWPvcoysg1l9QLs6pL/Ew0JVX28mALDjN0P0o=
Message-ID: <4DEE6903.9010501@gmail.com>
Date: Tue, 07 Jun 2011 11:08:03 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 2/3] kprobes/trace: Fix kprobe selftest for gcc 4.6
References: <20110607170740.235441001@goodmis.org> <20110607170827.295368694@goodmis.org>
In-Reply-To: <20110607170827.295368694@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 10:07 AM, Steven Rostedt wrote:
> From: Steven Rostedt<srostedt@redhat.com>
>
> With gcc 4.6, the self test kprobe function:
>
>   kprobe_trace_selftest_target()
>
> is optimized such that kallsyms does not list it. The kprobes
> test uses this function to insert a probe and test it. But
> it will fail the test if the function is not listed in kallsyms.
>
> Because the name is rather unique, converting it from static to
> global should not be a problem. This prevents gcc from removing
> it from kallsyms.
>
> Cc: Masami Hiramatsu<masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>   kernel/trace/trace_kprobe.c |    8 ++++++--
>   1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index f925c45..2c14378 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1870,8 +1870,12 @@ fs_initcall(init_kprobe_trace);
>
>   #ifdef CONFIG_FTRACE_STARTUP_TEST
>
> -static int kprobe_trace_selftest_target(int a1, int a2, int a3,
> -					int a4, int a5, int a6)
> +/*
> + * Can't be static, otherwise gcc might optimize this to
> + * not be in the kallsyms table.
> + */

Could you make it '__used' instead?

David Daney


> +int kprobe_trace_selftest_target(int a1, int a2, int a3,
> +				 int a4, int a5, int a6)
>   {
>   	return a1 + a2 + a3 + a4 + a5 + a6;
>   }

