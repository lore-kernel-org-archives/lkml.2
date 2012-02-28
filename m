Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2B1Tyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:54:55 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:61761 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2B1Tyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:54:54 -0500
Date: Tue, 28 Feb 2012 20:54:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Grant Grundler <grantgrundler@gmail.com>,
        John David Anglin <dave.anglin@bell.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
	for 64 bit.
Message-ID: <20120228195451.GA3042@merkur.ravnborg.org>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com> <4F4CF3CF.5090605@bell.net> <CANEJEGv2Zgtd8TGOzSNO8opMLQT8RsGRP=m2rBPUBBOJ9f+fKQ@mail.gmail.com> <201202281337.14094.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202281337.14094.vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 01:37:10PM -0500, Mike Frysinger wrote:
> On Tuesday 28 February 2012 13:22:50 Grant Grundler wrote:
> > On Tue, Feb 28, 2012 at 7:33 AM, John David Anglin wrote:
> > > On 2/28/2012 10:21 AM, Mike Frysinger wrote:
> > >> we've been using hppa2.0 for years.  gnuconfig certainly recognizes it:
> > >> $ grep hppa /usr/share/gnuconfig/config.**sub
> > >> 
> > >>         | h8300 | h8500 | hppa | hppa1.[01] | hppa2.0 | hppa2.0[nw] |
> > >> 
> > >> hppa64 \
> > >> 
> > >>         | hppa-* | hppa1.[01]-* | hppa2.0-* | hppa2.0[nw]-* | hppa64-* \
> > >> 
> > >> and i've seen diff projects key off of the hppa2.0* to enable newer
> > >> features by
> > >> default.
> > > 
> > > Some of the above are specific to HP-UX, but hppa1.1, hppa2.0, hppa and
> > > hppa64 are
> > > valid for Linux based on config.guess.
> > 
> > Mike, et al,
> > I'd suggest NOT using hppa2.0 as a surrogate for 64-bit build. I'd prefer
> > hppa64 if 64-bit is meant.
> > 
> > hppa2.0 can also mean PA2.0 compliant binary compiled using ILP32 model.
> > right?
> 
> i don't think that's what the proposed change does.  James' patch runs $(CC) 
> to find the active tuple, then replaces the first part with "hppa64" to get a 
> 64bit toolchain automatically.  but that magic only works when the tuple is 
> "hppa-xxx" and so will fail when the system is using "hppa2.0-xxx".
> 
> short story: the proposed change will additionally support turning "hppa2.0-
> linux-gnu" into "hppa64-linux-gnu" rather than the existing "only turns hppa-
> linux-gnu" into "hppa64-linux-gnu".

There is a small helper:

    cc-cross-prefix

Which may be used ifyou have two or mroe candidated for CROSS_COMPILE.

>From mips:
 CROSS_COMPILE := $(call cc-cross-prefix, $(tool-archpref)-linux-  $(tool-archpref)-linux-gnu-  $(tool-archpref)-unknown-linux-gnu-)

Dunno if this would help parisc in this case..

	Sam
