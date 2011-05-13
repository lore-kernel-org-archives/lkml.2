Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab1EMA3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:29:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45354 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab1EMA3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:29:39 -0400
X-AuditID: b753bd60-a32c7ba000003bac-89-4dcc7b704b04
X-AuditID: b753bd60-a32c7ba000003bac-89-4dcc7b704b04
Message-ID: <4DCC7B6E.9000909@hitachi.com>
Date: Fri, 13 May 2011 09:29:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/9] kprobes: Silence DEBUG_STRICT_USER_COPY_CHECKS=y
 warning
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org> <1305244212-19183-6-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1305244212-19183-6-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/13 8:50), Stephen Boyd wrote:
> Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
> warning:
> 
> In file included from arch/x86/include/asm/uaccess.h:573,
>                  from kernel/kprobes.c:55:
> In function 'copy_from_user',
>     inlined from 'write_enabled_file_bool' at
>     kernel/kprobes.c:2191:
> arch/x86/include/asm/uaccess_64.h:65:
> warning: call to 'copy_from_user_overflow' declared with
> attribute warning: copy_from_user() buffer size is not provably
> correct
> 
> presumably due to buf_size being signed causing GCC to fail to
> see that buf_size can't become negative.

Good catch! At least, since the "count" is size_t, buf_size
should be size_t too.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  kernel/kprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 7798181..1938187 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2185,7 +2185,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
>  	       const char __user *user_buf, size_t count, loff_t *ppos)
>  {
>  	char buf[32];
> -	int buf_size;
> +	size_t buf_size;
>  
>  	buf_size = min(count, (sizeof(buf)-1));
>  	if (copy_from_user(buf, user_buf, buf_size))


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
