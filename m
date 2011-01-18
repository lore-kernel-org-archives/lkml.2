Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1ARTxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:53:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497Ab1ARTxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:53:09 -0500
Date: Tue, 18 Jan 2011 19:52:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: maximilian attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Ralf =?iso-8859-1?Q?R=F6sch?= <ralf.roesch@rw-gmbh.de>,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild: create linux-headers package in deb-pkg
Message-ID: <20110118195258.GA21934@decadent.org.uk>
References: <1293201730-1583-1-git-send-email-tytso@mit.edu> <20101225112026.GF20262@vostochny.stro.at> <20110110174640.GA619@stro.at> <4D2F044E.7060607@suse.cz> <20110113143840.GN20262@vostochny.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110113143840.GN20262@vostochny.stro.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:38:41PM +0000, maximilian attems wrote:
> On Thu, Jan 13, 2011 at 02:55:26PM +0100, Michal Marek wrote:
[...]
> > BTW, here is a bugreport I got privately about
> > the very same issue:
> > On 12.1.2011 10:02, Ralf Rösch wrote:
> > | [...]
> > | Attached you will find a patch to complete the build successfully for my
> > | mipsel target.
> > | The dpkg --print-architecture shows i386 which results in error:
> > | dpkg-gencontrol: Fehler: aktuelle Host-Architektur »mipsel« erscheint
> > | nicht in der Architekturliste (i386) des Pakets
> > | (current host architecture 'mipsel' does not appear in package's list
> > i386)
> > | so I changed "arch" temporary to "any".
> > |
> > | It would be nice if it would be possible to make the kernel-headers
> > | installable on any host.
> > | They are needed very frequently for cross-compiling. (I already possible
> > | with dpkg force).
> 
> Added Ben Hutchings and d-kernel on Cc. I do not use OOT modules, so
> I don't have a strong word on that, but from what I see in Debian
> they are arch specific.

Kernel header packages should be labelled with the target architecture.
This is because the headers include some generated files that are both
architecture- and configuration-specific.

Any package of libraries or headers for some architecture is in theory
useful for cross-development on any other architecture, yet we do not
label them as architecture: all.  If we did that, we would then have to
use a different name and installation path for each target so that they
are co-installable; this would also bloat the package list files.  You
should normally be able to convert a package for use in cross-
development using dpkg-cross, which changes its name and paths
accordingly.  However I don't know how well this will work for kernel
headers.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
