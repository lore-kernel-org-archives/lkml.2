Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1CWNl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:41:27 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:57481 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1CWNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:41:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D89F8D0.7070108@cam.ac.uk>
Date: Wed, 23 Mar 2011 13:42:40 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
        adobriyan@gmail.com
Subject: Re: [PATCH 3/3] params.c: Use new kstrtobool implementation to processing
 boolean inputs.
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk> <1300887554-19031-4-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1300887554-19031-4-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. The patch title should probably make sense.

On 03/23/11 13:39, Jonathan Cameron wrote:
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  kernel/params.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index 0da1411..37b4d83 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -297,3 +297,4 @@ EXPORT_SYMBOL(param_ops_charp);
>  int param_set_bool(const char *val, const struct kernel_param *kp)
>  {
>  	bool v;
> +	int ret;
> 
>  	/* No equals means "set"... */
>  	if (!val) val = "1";
>  
>  	/* One of =[yYnN01] */
> -	switch (val[0]) {
> -	case 'y': case 'Y': case '1':
> -		v = true;
> -		break;
> -	case 'n': case 'N': case '0':
> -		v = false;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> +	ret = kstrtobool(val, &v);
> +	if (ret)
> +		return ret;
>  
>  	if (kp->flags & KPARAM_ISBOOL)
>  		*(bool *)kp->arg = v;

