Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2CLWWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:22:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53979 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab2CLWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:22:38 -0400
Date: Mon, 12 Mar 2012 17:22:27 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thomas Rast <trast@inf.ethz.ch>
Cc: Junio C Hamano <gitster@pobox.com>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org
Subject: Re: [PATCH] git-am: error out when seeing -b/--binary
Message-ID: <20120312222227.GC11362@burratino>
References: <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
 <20120312152004.GB9380@kroah.com>
 <20120312152453.GB12405@1wt.eu>
 <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
 <20120312165703.GB18791@burratino>
 <7vvcm9snko.fsf@alter.siamese.dyndns.org>
 <87399dpk48.fsf@thomas.inf.ethz.ch>
 <20120312215607.GB11362@burratino>
 <874ntto4t8.fsf@thomas.inf.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ntto4t8.fsf@thomas.inf.ethz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Rast wrote:
> Jonathan Nieder <jrnieder@gmail.com> writes:

>> Hm, on second thought, if people are seeing this message, I would
>> prefer if they write to the mailing list so we can find out about it.
>> So I really would rather see this say
>>
>> 	--binary)
>> 		: ;;
>>
>> and have "-b" completely unrecognized, without any words in our
>> defense except for a note in the release notes mentioning the option's
>> removal and that it has been an unadvertised backward-compatibility
>> no-op since 1.6.0.
>
> I'd hate doing that, mostly because other projects got me really angry
> about similar issues, e.g., 71c020c (Disable asciidoc 8.4.1+ semantics
> for `{plus}` and friends, 2009-07-25).

Oh, now that I think about it that way, you're definitely right.

So, how about something like this?

	--binary)
		: ;;
	-b)
		gettextln >&2 "The -b option (a no-op short for --binary) was removed in 1.7.10."
		die "$(gettext "Please adjust your scripts.")"
		;;

Mentioning deprecation in 1.6.0 in the message left me uneasy because
we never actually did anything to actively deprecate the option; it
just has not been needed since 1.4.3 and we stopped advertising it in
the manpage in 1.6.0.  So I don't like the implication of "this is all
right because we told you so" --- on the contrary, it is "in practice
nobody seems to be using this option and we hope nobody will notice
when we take it away".

Jonathan
