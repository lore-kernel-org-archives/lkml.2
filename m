Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0HDJ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:27:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab0HDJ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:27:17 -0400
Date: Wed, 4 Aug 2010 11:26:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Airlie <airlied@gmail.com>,
        Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
Message-ID: <20100804092658.GC2395@elte.hu>
References: <m11vagw2fl.fsf@fess.ebiederm.org>
 <4C57CD9C.70602@kernel.org>
 <m1fwywoz0f.fsf@fess.ebiederm.org>
 <4C57DACF.1090503@kernel.org>
 <m17hk8oy5g.fsf@fess.ebiederm.org>
 <4C57E32A.9070401@kernel.org>
 <m18w4onebi.fsf@fess.ebiederm.org>
 <4C5871BC.4070007@kernel.org>
 <m1bp9jgyww.fsf@fess.ebiederm.org>
 <4C592BF5.3070008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C592BF5.3070008@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 08/03/2010 02:38 PM, Eric W. Biederman wrote:
> > 
> > A clean solution would be to scrub the input from the MP table before
> > we attempt to use of it, instead of scrubbing the data as we use in
> > code paths like pin_2_irq.  Just touching pin_2_irq is certainly an
> > incomplete solution because you have not resolved if the pins should
> > be edge or level triggered, and what polarity we should be sampling
> > them at.
> > 
> > Until I see a plausible scenario where not handling buggy MP tables
> > exactly as we have done in the past I don't see hacks like you
> > are proposing making much sense at all.
> 
> ok, how about this one?
> 
> it will try to add entries to mp_irqs[] with some checking.

Yep, more sanity testing of BIOS data is welcome.

	Ingo
