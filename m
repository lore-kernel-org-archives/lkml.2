Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1JLS6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:58:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33325 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1JLS6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:58:15 -0400
Message-ID: <4E95E310.3050409@zytor.com>
Date: Wed, 12 Oct 2011 11:57:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        quilt-dev <quilt-dev@nongnu.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v3] quilt mail: Add way to sign mail with GPG
References: <1318262910.7904.94.camel@gandalf.stny.rr.com>  <1318379537.1887.25.camel@schurl.linbit>  <1318381107.7904.191.camel@gandalf.stny.rr.com> <1318413367.24907.15.camel@schurl.linbit>
In-Reply-To: <1318413367.24907.15.camel@schurl.linbit>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 02:56 AM, Andreas Gruenbacher wrote:
> 
>> As for removing the temp file, I just found it was the easiest way to
>> pipe into gpg. If there's a better way to do that, I'm all ears.
> 
> ... how about this approach?
> 
>     my @lines = <>;
>     map { print } @lines;
>     print "\n";
> 
>     #-----------------------------------------------
> 
>     sub crlf($) {
>         my $_ = shift;
>         #s/\n$/\r\n/;
>         s/^/> /;
>         return $_;
>     }
> 
>     my $command = 'tr a-z A-Z';
>     open(PIPE, "| $command")

open(PIPE, '|-', $command);

... please; better yet with a list (@command) so it doesn't doesn't pass
through the shell.

	-hpa
