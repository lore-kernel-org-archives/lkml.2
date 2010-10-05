Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab0JEHvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:51:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab0JEHvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:51:36 -0400
Date: Tue, 5 Oct 2010 09:51:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@novell.com>,
        heukelum@fastmail.fm, tglx@linutronix.de, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
Message-ID: <20101005075107.GC23608@elte.hu>
References: <20100916082816.GA25681@elte.hu>
 <4C91F3A30200007800016B64@vpn.id2.novell.com>
 <20100916101355.GA31458@elte.hu>
 <4C9219BC0200007800016C53@vpn.id2.novell.com>
 <4CA52AA5.5040402@zytor.com>
 <4CA9A69F.8000006@redhat.com>
 <4CA9F625.7090709@zytor.com>
 <4CA9FEE2.7000900@redhat.com>
 <4CAA1BA3.1010306@zytor.com>
 <4CAAD85B.7020607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAAD85B.7020607@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

>  On 10/04/2010 08:23 PM, H. Peter Anvin wrote:
> >On 10/04/2010 09:20 AM, Avi Kivity wrote:
> >>    On 10/04/2010 05:43 PM, H. Peter Anvin wrote:
> >>>  On 10/04/2010 03:04 AM, Avi Kivity wrote:
> >>>>    On 10/01/2010 02:26 AM, H. Peter Anvin wrote:
> >>>>>   ... but that doesn't work with the macros like movq_cfi.  On those, we
> >>>>>   could argue that at least people won't put $ on them, but cpp will still
> >>>>>   split them apart with spaces; this apparently causes problems at least
> >>>>>   as soon as there is an expression more complicated than addition
> >>>>>   involved (apparently plus signs are okay, but minus signs aren't!)
> >>>>
> >>>>   Likely due to the fact that a minus sign can later join with a number
> >>>>   and become a new token, but a plug sign cannot.
> >>>>
> >>>
> >>>  ... except the same thing applies to other operators, other than the
> >>>  plus sign.  This kind of characterization is insanely frustrating, and
> >>>  really doesn't seem to follow logical rules ... we had a previous one
> >>>  where changing a macro name from upper case to lower case made gas 2.16
> >>>  work...
> >>>  	
> >>
> >>  Well, / and * do join.  % doesn't.  In a way, + does.
> >>
> >>  cpp is not a pure text processing language.  It's specifically geared to
> >>  C, and is fairly creaky when applying it to something other than C (and
> >>  is only somewhat creaky when applying it to C).
> >>
> >
> >The problem isn't with cpp, though, it's with gas.  There are bugs in
> >the gas 2.16 macro features that don't apply to any other gas version,
> >before *or* after.
> 
> I see.
> 
> I suppose it isn't possible to refuse to build with the broken version?

We could leave it build-broken and ask for a version specific quirk that 
runs a simple sed script over the source to turns 'pushl_cfi' et al into 
'push', or so?

Thanks,

	Ingo
