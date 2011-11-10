Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1KJBwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:52:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41727 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1KJBwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:52:18 -0500
Date: Wed, 9 Nov 2011 19:52:12 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Jiri Polach <jiri.polach@seznam.cz>
Cc: 647095@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
Message-ID: <20111110015212.GB2399@elie.gateway.2wire.net>
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
 <1319988329.6759.88.camel@deadeye>
 <4EAE9D3A.7000108@atlas.cz>
 <4EB92181.5030500@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB92181.5030500@seznam.cz>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Jiri Polach wrote:

> On Ben's advice I am trying to locate the commit that causes the problem to
> appear more precisely using 'git bisect'. However, too many of generated
> revisions are unbootable so I have to use 'bisect skip' frequently.

Ok, so I've looked over the log at <http://bugs.debian.org/647095>, and
this seems totally weird.  Have I described the symptoms correctly below?
(Warning: I am making some guesses, especially at step 5.  In case of
doubt, see the bug log just mentioned.)

	1. Disable SMT in the BIOS.

	2. Boot a bad kernel.  /proc/cpuinfo (correctly) shows one entry
	   per core.

	3. "shutdown -h now".  Enter BIOS.  SMT is still disabled.
	   Don't save.

	4. Boot any kernel.  /proc/cpuinfo shows two entries per core.

	5. "shutdown -h now".  Boot any kernel.  /proc/cpuinfo still shows
	   two entries per core.

	6. "shutdown -h now".  Enter BIOS.  SMT is still disabled.  Save.
	   Now /proc/cpuinfo will (correctly) shows one entry per core.

Reproducible for Jiri with v3.0.4.

Result of bisecting: v2.6.38-rc1 exhibits the problem.  v2.6.37 and
many of the topic branches merged in the 2.6.38 merge window work ok.
Some other topic branches do not boot at all.

Jiri: if you have gitk installed, then "git bisect visualize" can help
get a sense of what's in the middle of the regression range.
"gitk --bisect --first-parent v2.6.37..v2.6.38-rc1" might be a good way
to find mainline commits to test before finding a topic branch to delve
into.

x86 people: do the symptoms seem familiar?  Any hints for tracking it
down?

Thanks and hope that helps,
Jonathan
