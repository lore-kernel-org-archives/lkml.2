Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2DOVzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:55:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50060 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab2DOVzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:55:37 -0400
Date: Mon, 16 Apr 2012 01:55:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] prctl.2: Add PR_SET_MM option description
Message-ID: <20120415215531.GA2229@moon>
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
 <1331326042-32558-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkgJm01K9+GhnouxUwOUW3gk+YiuHLfofrs7adWzEqqO8Q@mail.gmail.com>
 <20120320222424.GL14269@moon>
 <CAKgNAkghWdju=o1prxw8dXEVjf95a+jLpe+3oKeHRWN1UK_cKg@mail.gmail.com>
 <20120324061704.GA4324@moon>
 <CAKgNAkiqWe4ygWpAr4yEx09=SdS8qvXTwsuefQT1zq1w8t_qqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkiqWe4ygWpAr4yEx09=SdS8qvXTwsuefQT1zq1w8t_qqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 04:10:24PM +1200, Michael Kerrisk (man-pages) wrote:
> Hi Cyrill,
> 

Hi Michael,

> I've had a look at your PR_SET_MM patch for the prctl.2 man page. I've
> made various edits and added various FIXMEs relating to questions I
> have.
> 
> At this stage, please do *not* send me a new patch, Just add your
> responses to the FIXMES inline in a reply mail, and I'll further tune
> my patch before sending it to you for further review.
> 

OK (don't hesitate to poke me, if anything needed)
...
> +.TP
> +.BR PR_SET_MM_START_STACK
> +Set the start address of the stack.
> +The corresponding memory area must be readable and writable.
> +.TP
> +.BR PR_SET_MM_START_BRK
> +Set the address above which the program heap can be expanded with
> +.BR brk (2)
> +call.
> +.\" FIXME In the next sentence, shouldn't "not be greater" be "be greater"?
> +The address must not be greater than the ending address of
> +the current program data segment.

Yes, thanks!

> +.\" FIXME I completely rewrote the following sentence. Is it okay?

Looks great to me.

> +.\" FIXME Is the following error documented in ERRORS?
> +In addition, the combined size of the resulting heap and
> +the size of the data segment can't exceed the
> +.BR RLIMIT_DATA
> +resource limit (see
> +.BR setrlimit (2)).
> +.TP
> +.BR PR_SET_MM_BRK
> +Set the current
> +.BR brk (2)
> +value.
> +The requirements for the address are the same as for the
> +.BR PR_SET_MM_START_BRK
> +option.
> +.\" FIXME Delete or comment out the following? (until ========)
> +.\" None of the following constants exist in current kernel source
> +.\" What is the state of the kernel patches for these?

This should be in -mm tree, I think it could be commented out
until it hit mainline.

> +.TP
> +.BR PR_SET_MM_ARG_START
...
> +.RE
> +.\"
>  .SH "RETURN VALUE"
>  On success,
>  .BR PR_GET_DUMPABLE ,
> @@ -411,7 +549,9 @@ is not recognized.
>  is
>  .BR PR_MCE_KILL
>  or
> -.BR PR_MCE_KILL_GET ,
> +.BR PR_MCE_KILL_GET
> +or
> +.BR PR_SET_MM ,
>  and unused
>  .BR prctl ()
>  arguments were not specified as zero.
> @@ -429,6 +569,48 @@ or
>  .BR PR_SET_SECCOMP ,
>  and the kernel was not configured with
>  .BR CONFIG_SECCOMP .
> +.\" FIXME I added the following lengthy EINVAL entry. Is it correct?

Yes, looks good to me. Thanks! Btw, Michael, could you please send
me this page in plain text format please (may be provately to not
flood the list_? I'll re-check it.

	Cyrill
