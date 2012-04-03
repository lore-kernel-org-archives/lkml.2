Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2DCRlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:41:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33458 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210Ab2DCRlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:41:49 -0400
Message-ID: <1333474907.26079.57.camel@joe2Laptop>
Subject: Re: CodingStyle vs checkpatch for block comments
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 10:41:47 -0700
In-Reply-To: <4F7B32A0.1020009@tilera.com>
References: <1333195539-5421-1-git-send-email-consul.kautuk@gmail.com>
	 <4F7B2114.4000806@tilera.com>
	 <CAFPAmTTfYKT39gdoKT3P4G2O0xkTSS8g62kKudeLcnpdipzJqg@mail.gmail.com>
	 <4F7B21FB.3040609@tilera.com>
	 <CAFPAmTS_2H7BzGndcceBxdnJroy82u++sduCPO2+qxG6-WA=nw@mail.gmail.com>
	 <4F7B2766.9080208@tilera.com> <1333471474.26079.43.camel@joe2Laptop>
	 <4F7B2AA7.5010906@tilera.com> <1333472391.26079.47.camel@joe2Laptop>
	 <4F7B32A0.1020009@tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 13:25 -0400, Chris Metcalf wrote:
> (Adding linux-kernel to the cc's and restating the question...)
> 
> I accepted a patch from Kautuk Consul and adjusted his comment style, but
> he pointed out that he had changed his comment style based on a warning

It's a check not a warning.

> from checkpatch.
> 
> The Documentation/CodingStyle file says:
> 
>     The preferred style for long (multi-line) comments is:
> 
>        /*
>         * This is the preferred style for multi-line
>         * comments in the Linux kernel source code.
>         * Please use it consistently.
>         *
>         * Description:  A column of asterisks on the left side,
>         * with beginning and ending almost-blank lines.
>         */
> 
> However, a new change to "checkpatch --strict" by Joe Perches, commit
> aad4f61498, causes this construct to be flagged as a warning

checkpatch flags it with a "check" only when --strict
is on the checkpatch command line.

>  if (and only
> if) it is preceded by a blank line.  Joe said the change was to support
> David Miller's preferred style, but that he didn't much care one way or
> another.

I think the block comment style is less important than
the actual content of the block comment.  The actual
comment content is rather difficult for checkpatch to
parse though.

> The relevant code in checkpatch.pl is:
> 
>                 if ($rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
>                     $prevrawline =~ /^\+[ \t]*$/) {
>                         CHK("BLOCK_COMMENT_STYLE",
>                             "Don't begin block comments with only a /*
> line, use /* comment...\n" . $hereprev);
>                 }
> 
> So, my questions -
> 
> 1. I'm not sure what the regexps are really trying to avoid.  Presumably a
> blank line followed by a block comment is OK?  Certainly the kernel sources
> are full of this construct.

It emits a check message on
<blank line>
	/*

but not
<blank line>
	/* some actual comment

> 2. The actual warning message emitted seems to directly contradict the
> CodingStyle document, so presumably we should either clarify the message,
> or update CodingStyle if we're really trying to change the style.

Or just remove it or add a test for the patched file
to be in net/... or drivers/net... or something.

