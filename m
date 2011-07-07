Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1GGITj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:19:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55438 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1GGITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:19:35 -0400
Date: Thu, 7 Jul 2011 12:19:30 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>
Subject: Re: [kernel-hardening] Re: RLIMIT_NPROC check in set_user()
Message-ID: <20110707081930.GA4393@albatros>
References: <20110612130953.GA3709@albatros>
 <20110706173631.GA5431@albatros>
 <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
 <20110706185932.GB3299@albatros>
 <20110707075610.GA3411@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707075610.GA3411@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, I've dropped Linus from CC somehow ;-)

On Wed, Jul 06, 2011 at 22:59 +0400, Vasiliy Kulikov wrote:
> On Wed, Jul 06, 2011 at 11:01 -0700, Linus Torvalds wrote:
> > My reaction is: "let's just remote the crazy check from set_user()
> > entirely".
> 
> Honestly, I didn't expect such a positive reaction from you in the first
> reply :)
> 
> 
> > The whole point of RLIMIT_NPROC is to avoid fork-bombs.
> 
> It is also used in cases where there is implicit or explicit limit on
> some other resource per process leading to the global limit of
> RLIMIT_NPROC*X.  The most obvious case of X is RLIMIT_AS.
> 
> Purely pragmatic approach is introducing the check in execve() to
> heuristically limit the number of user processes.  If the program uses
> PAM to register a user session, maxlogins from pam_limits is the Right
> Way.  But many programs simply don't use PAM because of the performance
> issues.  E.g. apache doesn't use PAM.  On a shared web hosting this is a
> real issue.
> 
> In -ow patch execve() checked for the exceeded RLIMIT_NPROC, which
> effectively solved Apache's problem.
> 
> ...and execve() error handling is hard to miss ;-)
> 
> 
> > So let's keep it in kernel/fork.c where we actually create a *new*
> > process (and where everybody knows exactly what the limit means, and
> > people who don't check for error cases are just broken). And remove it
> > from everywhere else.
> 
> There are checks only in copy_process() and set_user().
> 
> Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
