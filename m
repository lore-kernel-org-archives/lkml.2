Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab2CLV4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:56:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47420 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab2CLV4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:56:18 -0400
Date: Mon, 12 Mar 2012 16:56:07 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thomas Rast <trast@inf.ethz.ch>
Cc: Junio C Hamano <gitster@pobox.com>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org
Subject: Re: [PATCH] git-am: error out when seeing -b/--binary
Message-ID: <20120312215607.GB11362@burratino>
References: <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
 <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
 <20120312152004.GB9380@kroah.com>
 <20120312152453.GB12405@1wt.eu>
 <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
 <20120312165703.GB18791@burratino>
 <7vvcm9snko.fsf@alter.siamese.dyndns.org>
 <87399dpk48.fsf@thomas.inf.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87399dpk48.fsf@thomas.inf.ethz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Rast wrote:

> Ok, but if I don't get to say anything about repurposing, can I at least
> make it an error message instead of just spewing out the "invalid
> option" help?

I don't mind either way.

[...]
> --- a/git-am.sh
> +++ b/git-am.sh
> @@ -380,7 +380,9 @@ do
>  	-i|--interactive)
>  		interactive=t ;;
>  	-b|--binary)
> -		: ;;
> +		echo >&2 "The -b/--binary option was deprecated in 1.6.0 and removed in 1.7.10."
> +		die "Please adjust your scripts."
> +		;;

Hm, on second thought, if people are seeing this message, I would
prefer if they write to the mailing list so we can find out about it.
So I really would rather see this say

	--binary)
		: ;;

and have "-b" completely unrecognized, without any words in our
defense except for a note in the release notes mentioning the option's
removal and that it has been an unadvertised backward-compatibility
no-op since 1.6.0.

Jonathan
