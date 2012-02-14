Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2BNM2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 07:28:13 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6124 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab2BNM2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 07:28:10 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q1ECRdFd032386
Subject: Re: Does the mq_timedreceive() fully implement the POSIX
 specification?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: K K <knewsgroup@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        adam.li@intel.com
Date: Tue, 14 Feb 2012 13:27:40 +0100
In-Reply-To: <CAEv6Xce7Xwgjfqs2E-3YvYryfSzvePBuBLEr8T_+6xQrjQ6XSA@mail.gmail.com>
References: <CAEv6XcdzB++iZX4qAzmQYCJwfspXAHB01qEQoS+G2+8F+bm5Zg@mail.gmail.com>
	 <1329123064.25984.303.camel@thorin>
	 <CAEv6XceZQibb7srVDHYcDDHLUuDL4HS8xu7FqOa45Cp3OujbpQ@mail.gmail.com>
	 <CAEv6Xce7Xwgjfqs2E-3YvYryfSzvePBuBLEr8T_+6xQrjQ6XSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329222461.25984.333.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

[ also Cc: the email address on the top on the test case. Therefore
self-quoting for the rest of the thread. ]

On Mon, 2012-02-13 at 09:51 +0100, Bernd Petrovitsch wrote:
> On Mon, 2012-02-13 at 10:30 +0800, K K wrote:
> [....]
> > I am doing POSIX test on linux. And for mq_timedreceive() in POSIX spec
> > 2008 Issue 7, Line 43787:
> > 
> >   The validity of the abstime parameter need not be checked if a
> >   message can be removed from the message queue immediately.
> > 
> > But when I run test case mq_timedreceive/10-2 of POSIX suite (can be viewed
> > at :
> > http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=blob;f=testcases/open_posix_testsuite/conformance/interfaces/mq_timedreceive/10-2.c;h=49ee4f243fc5046a965a551650d8697217faac35;hb=HEAD),
> > mq_timedreceive() could get the message without wait, but the timeout is
> > still validated.
> > 
> > Do we intend to do so, or the implementation needs update?
> 
> I'm not a native English speaker but there is IMHO no problem as the
> above quoted part of POSIX simply does not require the check in that
> case. But it doesn't forbid the check.

On Die, 2012-02-14 at 14:44 +0800, K K wrote:
[...]
> Under no circumstance shall the operation fail with a timeout if a message
> can be removed from
> the message queue immediately. The validity of the abstime parameter need
> not be checked if a
> message can be removed from the message queue immediately.
> 
> It seems that the first sentence is more affirmative that the timeout
> should not be checked when a message can be removed from message queue
> immediately.
> How do you think?

Well, and the sys-call actually does not fail with a *timeout* - which
is indicated with a return value == -1 and errno == ETIMEDOUT if I read
http://pubs.opengroup.org/onlinepubs/009695399/functions/mq_receive.html
correctly - but with some another error - return value == -1 and errno
== EINVAL.
So the first quoted sentence actually doesn't apply IMHO.

The test description in the second comment on 
http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=blob;f=testcases/open_posix_testsuite/conformance/interfaces/mq_timedreceive/10-2.c;h=49ee4f243fc5046a965a551650d8697217faac35;hb=HEAD
reparaphrases the above quoted part incorrectly IMHO. The test
implements the description at the top though.


	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

