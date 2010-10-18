Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab0JRTJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:09:51 -0400
Received: from mail.perches.com ([173.55.12.10]:3019 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0JRTJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:09:50 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>, "Ted Ts'o" <tytso@mit.edu>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1287426752.1998.2099.camel@laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
	 <1287303678.20968.37.camel@Joe-Laptop>
	 <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
	 <1287310889.1998.153.camel@laptop> <1287334498.20968.53.camel@Joe-Laptop>
	 <1287343839.1998.699.camel@laptop>
	 <AANLkTikaxf-Fh9qUxsXNO5=r+SoxbzYXvCjFcHQLcXjy@mail.gmail.com>
	 <1287345710.1998.735.camel@laptop>
	 <AANLkTimixEGQTYrM7ShodtKeC97e0uPNRhWQn8F+-Nui@mail.gmail.com>
	 <20101018143935.GA4120@thunk.org> <20101018145400.GD4120@thunk.org>
	 <1287413933.29097.1608.camel@twins>
	 <AANLkTin2joSMdqn_HKzQDHuV5cbwbLAB2hJi7Uj8yEHK@mail.gmail.com>
	 <1287426752.1998.2099.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 12:09:47 -0700
Message-ID: <1287428987.20968.156.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 20:32 +0200, Peter Zijlstra wrote:
> On Mon, 2010-10-18 at 14:21 -0400, Mike Frysinger wrote:
> > sounds like an ACK for Joe's patch

I didn't submit a patch, I suggested a possible improvement to
your patch.  If you agree with it, you could resubmit.

> There are checks I don't really like, for those I simply ignore its
> output, I suggest others do the same.

Seems sensible.

Mike, checkpatch does already allow a single space to precede
a label but there's a conflict between the leading spaces test
and this test below it, so something like your patch is useful.

----------------
#goto labels aren't indented, allow a single space however
		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
			WARN("labels should not be indented\n" . $herecurr);
		}
----------------

The leading space test may be overly noisy.
Maybe Andy can fix it a different way.

About 1% (~500) of the labels in the kernel source tree use
leading tabs.  I think that label style is harder for me to
visually scan and find, but it's probably not code I'd change
just for conformity.

