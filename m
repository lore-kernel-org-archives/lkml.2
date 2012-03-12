Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2CLGqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:46:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47178 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CLGql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:46:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="171567186"
Message-ID: <4F5D9BCF.3030302@codeaurora.org>
Date: Sun, 11 Mar 2012 23:46:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>
CC: mmarek@suse.cz, rostedt@goodmis.org, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Makefile: fix error when gen TAGS
References: <1331524397-19783-1-git-send-email-hamo.by@gmail.com>
In-Reply-To: <1331524397-19783-1-git-send-email-hamo.by@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2012 8:53 PM, Yang Bai wrote:
> scripts/tags.sh has a problem that it does not
> test which kind of tags we are generating and
> assumes tags. So when gen TAGS it shows:
>    GEN     TAGS
>    sed: can't read tags: No such file or directory
>    make: *** [TAGS] Error 2
>
> Signed-off-by: Yang Bai<hamo.by@gmail.com>
> ---
>   scripts/tags.sh |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 833813a..ce94e34 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -168,7 +168,11 @@ exuberant()
>   	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
>
>   	# Remove structure forward declarations.
> -	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
> +	if [[ -e tags ]]; then
> +	    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
> +	else
> +	    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' TAGS
> +	fi
>   }
>   

What does ctags --version print out for you? I'm not aware of exuberant 
tags outputting files called TAGS (although etags would do that and then 
this patch wouldn't make sense).

It would be nice if etags was updated to take care of this forward 
declaration removal. Care to send that patch?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

