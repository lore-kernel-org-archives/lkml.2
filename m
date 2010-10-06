Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab0JFMwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:52:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:56119 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790Ab0JFMwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:52:53 -0400
Message-ID: <4CAC7123.8090504@suse.cz>
Date: Wed, 06 Oct 2010 14:52:51 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Nicolas Palix <npalix.work@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Coccinelle: Improve user information with a new kind
 of comment
References: <1286225141-22027-1-git-send-email-npalix.work@gmail.com>
In-Reply-To: <1286225141-22027-1-git-send-email-npalix.work@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.10.2010 22:45, Nicolas Palix wrote:
> Improve user information with a new kind of comment
> about semantic patch output.
> 
> Fix spelling.
> 
> Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  scripts/coccicheck |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index b8bcf1f..4655551 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -25,7 +25,7 @@ fi
>  
>  if [ "$MODE" = "" ] ; then
>      if [ "$ONLINE" = "0" ] ; then
> -	echo 'You have not explicitly specify the mode to use. Fallback to "report".'
> +	echo 'You have not explicitly specified the mode to use. Fallback to "report".'
>  	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
>  	echo 'Available modes are: report, patch, context, org'
>      fi
> @@ -52,7 +52,12 @@ coccinelle () {
>  
>  	FILE=`echo $COCCI | sed "s|$srctree/||"`
>  
> -	echo "Processing `basename $COCCI` with option(s) \"$OPT\""
> +	echo "Processing `basename $COCCI`"
> +	echo "with option(s) \"$OPT\""
> +	echo 'Semantic patch information:'
> +
> +	sed -e '/\/\/#/!d' -e 's|^//#||' $COCCI

sed -ne 's|^//#||p' $COCCI :)

But I would put this after the "Message example to submit a patch".
free.cocci has the information in this order and it makes more sense
this way IMO (first general information, then details). And it would be
nice to only display the "Semantic patch information:" line if there
actually is some additional information in the semantic patch file.
Otherwise, the series looks OK to me.

> +
>  	echo 'Message example to submit a patch:'
>  
>  	sed -e '/\/\/\//!d' -e 's|^///||' $COCCI


Michal
