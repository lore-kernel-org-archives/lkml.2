Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1FCCuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:50:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1FCCuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:50:07 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=dZbmahTG33kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8-g6JaTKU-zsITgn01cA:9 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Fix compiler warning in ftrace.c
From: Steven Rostedt <rostedt@goodmis.org>
To: GuoWen Li <guowen.li.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201106011918.47939.guowen.li.linux@gmail.com>
References: <201106011918.47939.guowen.li.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 22:50:04 -0400
Message-ID: <1307069404.3667.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of things:

On Wed, 2011-06-01 at 19:18 +0800, GuoWen Li wrote:
> kernel/trace/ftrace.c: In function ‘ftrace_regex_write.clone.15’:
> kernel/trace/ftrace.c:2743:6: warning: ‘ret’ may be used uninitialized in this 
> function
> 
> Signed-off-by: GuoWen Li

Please add your mail address to your SOB. (I'll fix it)

> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 1ee417f..204b3eb 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2740,7 +2740,7 @@ static int ftrace_process_regex(struct ftrace_hash 
> *hash,
>  {
>         char *func, *command, *next = buff;
>         struct ftrace_func_command *p;
> -       int ret;
> +       int ret = -EINVAL;

This patch has horrible white space issues. (I fixed it)

-- Steve


>  
>         func = strsep(&next, ":");


