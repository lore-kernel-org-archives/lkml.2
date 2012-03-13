Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab2CMVr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:47:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab2CMVrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:47:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: Corrupted files after suspend to disk
Date: Tue, 13 Mar 2012 22:52:06 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, keithp@keithp.com
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <20120312214914.GA8628@redhat.com> <4F5F0C59.3000400@01019freenet.de>
In-Reply-To: <4F5F0C59.3000400@01019freenet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132252.06417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 13, 2012, Andreas Hartmann wrote:
> Dave Jones wrote:
> > On Mon, Mar 12, 2012 at 02:24:00PM +0100, Andreas Hartmann wrote:
> >  
> >  > >>>>> This is happening to me as well. Something like 1 resume out of 5 goes
> >  > >>>>> wrong this very same way.
> >  > >>>>>
> >  > >>>>> This is thinkpad x200s.
> >  > >>>>>
> >  > >>>>> All the userspace is segfaulting all over the place (most frequently in
> >  > >>>>> libselinux for some reason).
> >  > >>>>>
> >  > >>>>> I am not able to verify the 'drop_caches' theory, as I can't invoke a
> >  > >>>>> single command that wouldn't crash.
> >  > >>>>
> >  > >>>> The question is how should we proceed?
> >  > >>>> I've reported this issue one year (!!!) ago.
> >  > >>>
> >  > >>> Hmm, 3.3-rcX seems to be the first version when it started to happen to
> >  > >>> me. I take it that you have seen this also with 3.2? 3.1?
> >  > >>
> >  > >> Quote from my very first email:
> >  > >> "I'm facing a very strange problem on my netbook (Lenovo Ideapad S10)
> >  > >> running Linux 2.6.37.4."
> >  > > 
> >  > > So we both seem to have Lenovos at least. I thus wanted to verify whether 
> >  > > the problem will trigger with thinkpad_acpi removed, but it oopsed while 
> >  > > rmmoding :) I will start looking into this right away.
> >  > > 
> >  > > Is your system using thinkpad_acpi as well?
> >  > 
> >  > I dont't think, that it is lenovo related as I'm having a MSI machine.
> >  > 
> >  > https://bugzilla.novell.com/show_bug.cgi?id=732908
> >  > 
> >  > Following the link, you are able to compare the used chips - maybe there
> >  > are some equal components?
> > 
> > This looks like the i915 corruption problem mentioned in a few other threads.
> > 
> > if you compare the hexdump of the good/bad files, you find that the corruption
> > happens in 8x 4 byte writes of either 0x00000000 or 0x00aaaaaa.
> > 
> > KeithP clued me in last week that that looks like an ARGB pixel quad, so these
> > writes are likely 8 pixel strips.
> 
> Thanks Dave. I disabled i915 (with nomodeset) and voila, the problem
> disappears. As I already know, that the problem isn't X-related (I saw
> it even without any X involved, only with runlevel 3 and nothing more),
> the problem seems to be now narrowed down to the relevant component.

I wonder what's the kernel command line you can reproduce the problem with?

Rafael
