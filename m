Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2CLV5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:57:36 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:62224 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab2CLV5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=v/FzuLqOhxbzMg/u1lpWpPK5f1ALtYot
	3H0X3SGkMghL6JUKuTSzqI1ZHJVktRBotPY/oWm+YQZYQJVfVbPhj2ejSDWol6ve
	WcANiLq4zLTX8QyHLbZpBmY7GHSQv3uPIlVIFphaAVRefS4O5mKHYBhEhDNr4dKa
	nN+UvF9zXQo=
From: Junio C Hamano <gitster@pobox.com>
To: Thomas Rast <trast@inf.ethz.ch>
Cc: Junio C Hamano <gitster@pobox.com>, Jonathan Nieder <jrnieder@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <git@vger.kernel.org>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu> <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu> <20120312152004.GB9380@kroah.com>
 <20120312152453.GB12405@1wt.eu> <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
 <20120312165703.GB18791@burratino> <7vvcm9snko.fsf@alter.siamese.dyndns.org>
 <87399dpk48.fsf@thomas.inf.ethz.ch>
Date: Mon, 12 Mar 2012 14:57:26 -0700
In-Reply-To: <87399dpk48.fsf@thomas.inf.ethz.ch> (Thomas Rast's message of
 "Mon, 12 Mar 2012 22:47:19 +0100")
Message-ID: <7v399dpjnd.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 5BB59F26-6C8E-11E1-B0FE-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Rast <trast@inf.ethz.ch> writes:

>> We can delete "git am -b" (as it was deprecated long time ago), wait
>> for a cycle or two, and then repurpose it.  I do not mind starting
>> the first step (delete, but do not say anything about repurposing)
>> before 1.7.10-rc1 happens.
>
> Ok, but if I don't get to say anything about repurposing, can I at least
> make it an error message instead of just spewing out the "invalid
> option" help?

Surely.  It is not "Am I at least allowed to say" at all; we really
_should_ make it clear why it is no longer supported.

What I meant was that "it will start meaning something different" is
not a relevant thing to see when somebody sees his old script that
uses "-b" breaks.

Let's apply your patch so that we do not have to wait one cycle too
long.

Thanks.

>
> ----- 8< -----
> Subject: [PATCH] git-am: error out when seeing -b/--binary
>
> The --binary option to git-apply has been a no-op since 2b6eef9 (Make
> apply --binary a no-op., 2006-09-06) and was deprecated in cb3a160
> (git-am: ignore --binary option, 2008-08-09).
>
> We could remove it outright, but let's be nice to people who still
> have scripts saying 'git am -b' (if they exist) and tell them the
> reason for the sudden failure.
>
> Signed-off-by: Thomas Rast <trast@student.ethz.ch>
> ---
>  git-am.sh |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/git-am.sh b/git-am.sh
> index 0bd290b..faae820 100755
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
>  	-3|--3way)
>  		threeway=t ;;
>  	-s|--signoff)
