Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2FVSsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:48:52 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:39706 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755884Ab2FVSsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:48:50 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 14:48:50 EDT
Date: Fri, 22 Jun 2012 20:38:28 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20120622183827.GA8014@virgo.local>
References: <20120622133650.GA24136@gmail.com>
 <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds | 2012-06-22 11:07:01 [-0700]:

>And gcc can (and does, depending on version and details) inline pretty
>much any static function, whether we mark it inline or not.
>
>Now, there's no question that we don't want inlined functions to be
>traced, but that actually means that the *logical* thing would be to
>try to somehow tell gcc to not ever do the whole stupid mcount thing
>for functions that *might* be inlined - and at least be consistent
>about it.
>
>IOW, is there some way to get the mcount thing to only happen for
>functions that either have their address taken, or have external
>visibility?
>
>Because that mcount thing is expensive as hell, if people haven't
>noticed (and I'm not talking about just the call instruction that I
>think we can stub out - it changes code generation in other ways too).
>And it looks like distros enable it by default, which annoys my
>performance-optimizing soul deeply.

Isn't it stubed out already? Already replaced by nops at boot time by
ftrace_code_disable() and friends!? But yes, there may be spots where the
additional mcount() call avoid optimization.

Hagen
