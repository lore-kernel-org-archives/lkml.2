Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1CRKXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 06:23:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab1CRKXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 06:23:32 -0400
Date: Fri, 18 Mar 2011 11:22:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Banks <gnb@fmeh.org>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 05/50] Dynamic debug: Add more flags
Message-ID: <20110318102232.GA30751@elte.hu>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
 <1300309888-5028-5-git-send-email-gregkh@suse.de>
 <20110317175607.GD2648@redhat.com>
 <20110317180204.GA15205@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317180204.GA15205@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> On Thu, Mar 17, 2011 at 01:56:08PM -0400, Jason Baron wrote:
> > On Wed, Mar 16, 2011 at 02:10:43PM -0700, Greg Kroah-Hartman wrote:
> > > Add flags that allow the user to specify via debugfs whether or not the
> > > module name, function name, line number and/or thread ID have to be
> > > included in the printed message.
> > 
> > This piece is going to conflict with the jump label update patches, I'm
> > trying to get into .39. The 'if (unlikely(descriptor.enabled))' bit is
> > now: 'if (DDEBUG_BRANCH(descriptor.enabled))'. So its a small conflict,
> > but they wouldn't merge together. So we need to adjust either one (and
> > make sure they're applied in the correct orer), or drop one.
> 
> This has been in linux-next for months now, [...]

Btw, a workflow observation, i'd have expected such a commit:

 > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
 > Cc: Greg Banks <gnb@fmeh.org>
 > Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
 > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
 > ---
 >  Documentation/dynamic-debug-howto.txt |   12 +++++-
 >  include/linux/dynamic_debug.h         |    8 ++++-
 >  lib/dynamic_debug.c                   |   60 ++++++++++++++++++++++++++++-----
 >  3 files changed, 68 insertions(+), 12 deletions(-)

... to at least have the ack from Jason who is the author and maintainer of the 
dyn-printk bits. You should at least have Cc:-ed him!

Preferably it should have been merged through him. That would also have alerted 
him to the conflict potential and would have concentrated all changes in a 
single tree, as it really should happen ...

So could you *please* do such changes in a bit more organized fashion in the 
future? Please use the get_maintainer script:

  $ scripts/get_maintainer.pl -f lib/dynamic_debug.c 

  Jason Baron <jbaron@redhat.com> (commit_signer:6/10=60%)
  Thomas Renninger <trenn@suse.de> (commit_signer:3/10=30%)
  Pekka Enberg <penberg@cs.helsinki.fi> (commit_signer:3/10=30%)
  Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:3/10=30%)
  Steven Rostedt <rostedt@goodmis.org> (commit_signer:2/10=20%)
  linux-kernel@vger.kernel.org (open list)

The majority of those gents were not Cc:-ed to any of the submissions and 
resubmissions.

To answer your question, the in-flight changes Jason is talking about have not 
touched linux-next yet because they went through several levels of review 
feedback. Had your patches gone through a similar review process they might 
still be in flight as well and we'd also have found out about any conflicts 
sooner.

Thanks,

	Ingo
