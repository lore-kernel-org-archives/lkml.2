Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1GAMBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:01:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41838 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab1GAMBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:01:20 -0400
Date: Fri, 1 Jul 2011 14:00:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110701120059.GL20990@elte.hu>
References: <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jun 27, 2011 at 11:38 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >
> > Sure, I don't propose it anymore (v2 goes without it).
> 
> What point would you like to filter things at?
> 
> I really think that user space should do its own filtering - nobody
> does a plain 'cat' on dmesg. Or if they do, they really have
> themselves to blame.
> 
> And afaik, we don't do any escape sequence handling at the console
> level either, so you cannot mess up the console with control
> characters.
> 
> And the most dangerous character seems to be one that you don't
> filter: the one we really do react to is '\n', and you could possibly
> make confusing log messages by embedding a newline in your string and
> then trying to make the rest look like something bad (say, an oops).
> 
> So I'm not entirely convinced about this filtering at all.

Yeah. It would be nice to see a demonstration of at least one 'bad 
thing' that is possible via the current code, before we protect 
against it.

The claim the patch makes is rather specific:

 | There are numerous printk() instances with user supplied input as 
 | "%s" data, and unprivileged user may craft log messages with 
 | substrings containing control characters via these printk()s.  
 | Control characters might fool root viewing the logs via tty, e.g. 
 | using ^[1A to suppress the previous log line.

So it ought to be demonstrable.

Thanks,

	Ingo
