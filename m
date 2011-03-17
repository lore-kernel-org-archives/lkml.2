Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1CQTgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:36:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56108 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1CQTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:36:47 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=cjxWWOd7KoAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=J5U1FVrK8QhXG97FSOoA:9 a=UTfNkxfrOrUh_EbeD3MA:7 a=lHXlGb4uG0vSEh179T3Qj9gsrocA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 17 Mar 2011 15:36:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
Message-ID: <20110317193645.GD14675@home.goodmis.org>
References: <20110317045209.GA18656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317045209.GA18656@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 12:52:09AM -0400, Dave Jones wrote:
> Because the second and third arguments of memset have the same type,
> it turns out to be really easy to mix them up.
> 
> This bug comes up time after time, so checkpatch should really
> be checking for it at patch submission time.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 58848e3..421b3e69 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2902,6 +2902,11 @@ sub process {
>  		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
>  			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
>  		}
> +
> +		# Check for memset with swapped arguments
> +		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {

Wouldn't this be a better regex:

	if ($line =~ /memset.*\,\s*(0x)?0\s*\)\s*;/)

-- Steve

> +			ERROR("memset size is 3rd argument, not the second.\n" . $herecurr);
> +		}
>  	}
>  
>  	# If we have no input at all, then there is nothing to report on
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
