Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1FGTAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:00:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39397 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1FGTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WEAz1kwG6Cx7uKHCCwZmeN92TjGRh8MKuUfWQRhJJgsik7j+FvR7mvzO9Y2o0ExKV2
         fLf8cnMR18n5SLaRufXLoUND8ZOGkmhjmnx2VP71HzfYwTUIbjCCHkGnINJiJK4MH61J
         kS4l5cDd1nu9gBV8/tVk3cRDy0nL0AO9UE9qg=
Message-ID: <4DEE754B.1020706@suse.cz>
Date: Tue, 07 Jun 2011 21:00:27 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Xiaotian Feng <dfeng@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] do_coredump: fix the "ispipe" error check
References: <1307457010-7241-1-git-send-email-jslaby@suse.cz> <20110607181607.GA3732@redhat.com> <20110607183542.GA5559@redhat.com>
In-Reply-To: <20110607183542.GA5559@redhat.com>
X-Enigmail-Version: 1.2a2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 08:35 PM, Oleg Nesterov wrote:
> do_coredump() assumes that if format_corename() fails it should
> return -ENOMEM. This is not true, for example cn_print_exe_file()
> can propagate the error from d_path. Even if it was true, this is
> too fragile. Change the code to check "ispipe < 0".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Jiri Slaby <jslaby@suse.cz>

> ---
> 
>  fs/exec.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- ptrace/fs/exec.c~corename_errcode	2011-06-07 19:44:30.000000000 +0200
> +++ ptrace/fs/exec.c	2011-06-07 20:20:48.000000000 +0200
> @@ -2092,16 +2092,16 @@ void do_coredump(long signr, int exit_co
>  
>  	ispipe = format_corename(&cn, signr);
>  
> -	if (ispipe == -ENOMEM) {
> -		printk(KERN_WARNING "format_corename failed\n");
> -		printk(KERN_WARNING "Aborting core\n");
> -		goto fail_corename;
> -	}
> -
>   	if (ispipe) {
>  		int dump_count;
>  		char **helper_argv;
>  
> +		if (ispipe < 0) {
> +			printk(KERN_WARNING "format_corename failed\n");
> +			printk(KERN_WARNING "Aborting core\n");
> +			goto fail_corename;
> +		}
> +
>  		if (cprm.limit == 1) {
>  			/*
>  			 * Normally core limits are irrelevant to pipes, since
> 

thanks,
-- 
js
suse labs
