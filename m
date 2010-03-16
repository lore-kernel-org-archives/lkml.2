Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966131Ab0CPKXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:23:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57155 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966104Ab0CPKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:23:24 -0400
Date: Tue, 16 Mar 2010 11:23:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: T?r?k Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: fix callgraphs of 32-bit processes on 64-bit kernels.
Message-ID: <20100316102313.GD10069@elte.hu>
References: <1268667260-5505-1-git-send-email-edwintorok@gmail.com>
 <4B9E5EFF.1080308@gmail.com>
 <4B9F3EEC.7050104@gmail.com>
 <20100316084714.GB7961@elte.hu>
 <4B9F5ABE.7040705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F5ABE.7040705@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* T?r?k Edwin <edwintorok@gmail.com> wrote:

> On 03/16/2010 10:47 AM, Ingo Molnar wrote:
> > * T??r??k Edwin <edwintorok@gmail.com> wrote:
> > 
> >> On 03/15/2010 06:23 PM, T??r??k Edwin wrote:
> >>> On 03/15/2010 05:34 PM, T??r??k Edwin wrote:
> >>>> It would be good if perf knew how to lookup symbols in kernel modules!
> >>> BTW perf report -m -k /home/edwin/builds/linux-2.6/vmlinux doesn't show
> >>> the symbols either.
> >> I always forget that, unlike every other program, perf doesn't install
> >> by default to /usr/local!
> >> So I was running the wrong version of perf (from an older kernel), since
> >> perf was installed to $HOME/bin (which of course isn't in sudo's path).
> >>
> >> Sorry for the confusion, the 2.6.33 perf DOES know how to lookup the
> >> symbols:
> >>     9.92%  glxgears  [radeon]                           [k]
> >> r600_packet3_check
> >>             |
> >>             --- r600_packet3_check
> >>                |
> >>                |--96.80%-- r600_cs_parse
> > 
> > Ok, great!
> 
> BTW the patch I sent yesterday for tracing 32-bit apps is still needed, 
> since that is a kernel patch, and it wasn't due to using the wrong perf.

I've Cc:-ed Frederic for that bug. (Frederic has written a good deal of that 
code)

> > I suspect we could install into /usr/local too. Do you want to send a patch 
> > for that?
> 
> Sent.
> 
> BTW I think perf would need some documentation on how to install, and what 
> packages you need to build everything, what permissions it needs to run, 
> etc.

Agreed. (I've Cc:-ed Arnaldo who has a pending fix in this area.)

	Ingo
