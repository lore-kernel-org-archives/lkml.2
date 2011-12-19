Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1LSQVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:21:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1LSQVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:21:30 -0500
Date: Mon, 19 Dec 2011 17:19:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH v2] oprofile: Fix uninitialized memory access when
 writing to
Message-ID: <20111219161932.GA10017@elte.hu>
References: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
 <20111219140049.GA9097@elte.hu>
 <20111219141703.GG16765@erda.amd.com>
 <20111219153830.GH16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219153830.GH16765@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 19.12.11 15:17:03, Robert Richter wrote:
> > On 19.12.11 15:00:49, Ingo Molnar wrote:
> > 
> > > +	if (!count)
> > > +		return 0;
> > > +
> > >  	retval = oprofilefs_ulong_from_user(&value, buf, count);
> > >  	if (retval)
> > >  		return retval;
> > > 
> > > See the ugly and fragile pattern?
> > > 
> > > This should *really* be solved via the 
> > > oprofilefs_ulong_from_user() helper function, not by sprinkling 
> > > the !count checks in half a dozen places ...
> > 
> > Hmm, I thought there was no way to leave the code path with count == 0
> > and retval. But thinking about it it would be possible with returning
> > count or errors < 0. Will improve the patch.
> 
> Ingo, see my updated version below. [...]

Yeah, this looks a lot cleaner.

> [...] I am fine with appling it directly on tip/perf/urgent.

Applied,

Thanks,

	Ingo
