Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2CLVtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:49:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab2CLVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:49:52 -0400
Date: Mon, 12 Mar 2012 17:49:15 -0400
From: Dave Jones <davej@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Jiri Kosina <jkosina@suse.cz>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        keithp@keithp.com
Subject: Re: Corrupted files after suspend to disk
Message-ID: <20120312214914.GA8628@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	Jiri Kosina <jkosina@suse.cz>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	keithp@keithp.com
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
 <jj684d$6ng$1@ID-44327.news.uni-berlin.de>
 <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com>
 <4F574113.8030906@01019freenet.de>
 <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
 <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
 <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz>
 <CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com>
 <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
 <4F5DF8F0.5010801@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DF8F0.5010801@01019freenet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 02:24:00PM +0100, Andreas Hartmann wrote:
 
 > >>>>> This is happening to me as well. Something like 1 resume out of 5 goes
 > >>>>> wrong this very same way.
 > >>>>>
 > >>>>> This is thinkpad x200s.
 > >>>>>
 > >>>>> All the userspace is segfaulting all over the place (most frequently in
 > >>>>> libselinux for some reason).
 > >>>>>
 > >>>>> I am not able to verify the 'drop_caches' theory, as I can't invoke a
 > >>>>> single command that wouldn't crash.
 > >>>>
 > >>>> The question is how should we proceed?
 > >>>> I've reported this issue one year (!!!) ago.
 > >>>
 > >>> Hmm, 3.3-rcX seems to be the first version when it started to happen to
 > >>> me. I take it that you have seen this also with 3.2? 3.1?
 > >>
 > >> Quote from my very first email:
 > >> "I'm facing a very strange problem on my netbook (Lenovo Ideapad S10)
 > >> running Linux 2.6.37.4."
 > > 
 > > So we both seem to have Lenovos at least. I thus wanted to verify whether 
 > > the problem will trigger with thinkpad_acpi removed, but it oopsed while 
 > > rmmoding :) I will start looking into this right away.
 > > 
 > > Is your system using thinkpad_acpi as well?
 > 
 > I dont't think, that it is lenovo related as I'm having a MSI machine.
 > 
 > https://bugzilla.novell.com/show_bug.cgi?id=732908
 > 
 > Following the link, you are able to compare the used chips - maybe there
 > are some equal components?

This looks like the i915 corruption problem mentioned in a few other threads.

if you compare the hexdump of the good/bad files, you find that the corruption
happens in 8x 4 byte writes of either 0x00000000 or 0x00aaaaaa.

KeithP clued me in last week that that looks like an ARGB pixel quad, so these
writes are likely 8 pixel strips.

	Dave
