Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2EGKtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:49:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58240 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab2EGKtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:49:47 -0400
Date: Mon, 7 May 2012 12:49:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul
 cleanup
Message-ID: <20120507104943.GA3896@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Shuah Khan <shuahkhan@gmail.com>, mingo@redhat.com, hpa@zytor.com,
	tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1336324264.2897.9.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336324264.2897.9.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 11:11:04AM -0600, Shuah Khan wrote:
> Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
> instead of calling obsoleted simple_strtoul().
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>

Ok, much better, thanks.

@Ingo: I'll pick this one up unless you want to do that :-).

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

-- 
Regards/Gruss,
Boris.
