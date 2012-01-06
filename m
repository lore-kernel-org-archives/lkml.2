Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2AFHhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 02:37:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab2AFHhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 02:37:12 -0500
Date: Fri, 6 Jan 2012 08:34:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Nick Bowler <nbowler@elliptictech.com>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
Message-ID: <20120106073456.GB14188@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
 <20120105143008.GA31728@elliptictech.com>
 <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
 <20120105200810.GA3826@elliptictech.com>
 <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
 <4F065704.4020306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F065704.4020306@redhat.com>
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


* Rik van Riel <riel@redhat.com> wrote:

> On 01/05/2012 03:55 PM, Kees Cook wrote:
> >On Thu, Jan 5, 2012 at 12:08 PM, Nick Bowler<nbowler@elliptictech.com>  wrote:
> 
> >>But this is a brand new feature that changes longstanding behaviour of
> >>various syscalls.  Making it default to enabled is rather mean to users
> >>(since it will tend to get enabled by "oldconfig") and seems almost
> >>guaranteed to cause regressions.
> >
> > I couldn't disagree more. There has been zero evidence of 
> > this change causing anything but regressions in _attacks_. 
> > :P If anything, I think there should be no CONFIG and no 
> > sysctl, and it should be entirely non-optional. But since 
> > this patch needs consensus, I have provided knobs to control 
> > it.
> 
> I agree with you, Kees.
> 
> The behaviour introduced by this patch should produce so few 
> issues, that the new behaviour should probably be on by 
> default.

Up to the point people report regressions.

And yes, I think Kees is perfectly right that the setting of the 
default should be evidence based. (Assuming Al and Linus is fine 
with the whole concept.)

The only specific counter-argument I can see is the spinlock 
performance impact I raised during review. I think we can (and 
should) live with that, and it's probably fixable, BYMMV.

Thanks,

	Ingo
