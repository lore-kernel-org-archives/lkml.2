Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2EFKDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 06:03:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab2EFKDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 06:03:18 -0400
Date: Sun, 6 May 2012 12:03:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kernel/microcode_core.c simple_strtoul cleanup
Message-ID: <20120506100314.GB27678@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Shuah Khan <shuahkhan@gmail.com>, mingo@redhat.com, hpa@zytor.com,
	tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1336232259.3038.8.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336232259.3038.8.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 09:37:39AM -0600, Shuah Khan wrote:
> Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
> instead of calling obsoleted simple_strtoul().
> 
> From 8df8b8f87a8e462faa7b4c2b4682b23df5afa4bd Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Fri, 4 May 2012 14:12:11 -0600
> Subject: [PATCH] x86: kernel/microcode_core.c simple_strtoul cleanup
> 
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>  arch/x86/kernel/microcode_core.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index c9bda6d..fbdfc69 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -299,12 +299,11 @@ static ssize_t reload_store(struct device *dev,
>  {
>  	unsigned long val;
>  	int cpu = dev->id;
> -	int ret = 0;
> -	char *end;
> +	ssize_t ret = 0;
>  
> -	val = simple_strtoul(buf, &end, 0);
> -	if (end == buf)
> -		return -EINVAL;
> +	ret = kstrtoul(buf, 0, &val);
> +	if (ret)
> +		return ret;
>  
>  	if (val == 1) {
>  		get_online_cpus();
> -- 
> 1.7.9.5

Patch looks correct but your patch format looks all flipped: first you
have the commit message and then the mail headers you get from git
format-patch, what happened? IOW, it should be the other way around.

Go look at other messages on lkml starting with "tip-bot" in the From:
for a proper patch formatting pls.

Thanks.

-- 
Regards/Gruss,
    Boris.
