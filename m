Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2B2T6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:58:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48013 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752986Ab2B2T6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:58:48 -0500
Message-ID: <1330545526.22465.5.camel@joe2Laptop>
Subject: Re: [PATCH] get_maintainer.pl: Add support for moderated lists
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, Ian.Campbell@citrix.com, florian@mickler.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 11:58:46 -0800
In-Reply-To: <1330544962-995-1-git-send-email-richard@nod.at>
References: <1330544962-995-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 20:49 +0100, Richard Weinberger wrote:
> Currently get_maintainer.pl reports moderated lists as open,
> which is just wrong.

Hi Richard.

<shrug>  From my perspective, it's correct and simple.

Moderated lists just means your email may get delayed
and you may get a "delayed due to moderation" email.

It's not a big deal to me though if Andrew wants to pick
this up.  It seems that all current lists are marked
the same way.  You might consider using a case insensitive
m/\(moderated/i though in case some list has moderated
in the email address itself.

cheers, Joe

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  scripts/get_maintainer.pl |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index f32a04c..b9bcfb6 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -1027,8 +1027,13 @@ sub add_categories {
>  		    if ($email_list) {
>  			if (!$hash_list_to{lc($list_address)}) {
>  			    $hash_list_to{lc($list_address)} = 1;
> -			    push(@list_to, [$list_address,
> -					    "open list${list_role}"]);
> +			    if ($list_additional =~ m/moderated/) {
> +				push(@list_to, [$list_address,
> +						"moderated list${list_role}"]);
> +			    } else {
> +				push(@list_to, [$list_address,
> +						"open list${list_role}"]);
> +			    }
>  			}
>  		    }
>  		}



