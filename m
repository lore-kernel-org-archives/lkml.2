Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755Ab2CAOfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:35:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6089 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519Ab2CAOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:35:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Mar 2012 06:35:30 -0800
Date: Thu, 1 Mar 2012 16:35:13 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, "Olof Johansson" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 00/10] Add tegra30 support for secondary cores
Message-ID: <20120301143513.GR12917@tbergstrom-lnx.Nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
 <20120229154229.GL12917@tbergstrom-lnx.Nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BDDF21F3@HQMAIL01.nvidia.com>
 <20120301114211.GP12917@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120301114211.GP12917@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 12:42:11PM +0100, Peter De Schrijver wrote:
> On Wed, Feb 29, 2012 at 11:38:16PM +0100, Stephen Warren wrote:
> > Peter De Schrijver wrote at Wednesday, February 29, 2012 8:42 AM:
> > > On Wed, Feb 15, 2012 at 10:27:43PM +0100, Stephen Warren wrote:
> > > > Peter De Schrijver wrote at Thursday, February 09, 2012 4:48 PM:
> > > > > This patchset introduces support for secondary cores on tegra30. It also
> > > > > introduces some functions for the flowcontroller and adds basic support for
> > > > > tegra30 powerdomains.
> > > >
> > > > The code looks fine to me. I do notice the following when running
> > > > "shutdown -h now":
> > > >
> > > > [   27.762124] SMP: failed to stop secondary CPUs
> > 
> > I can't seem to reproduce this at all on next-20120229 anymore. What
> > kind of repro frequency are you seeing, and does it get fixed if you
> > update to that baseline?
> > 
> 
> I see it abount once every 3 reboots. I have a an expect script which
> automates the test. I haven't tried with next-20120229 yet.
> 
> > (I tried 20 times with shutdown, and 15 of them I reverted all the CPU
> > and cache errata in case they affected the issue at all)

Tried it with next-20120229 and it works fine here. I also noticed
next-20120229 does not have https://lkml.org/lkml/2012/1/31/444
which was part of the earlier tree I used for testing. So num_online_cpus()
recalculates the number of online CPUs everytime instead of trying to only
recalculate it when there is a change.

Cheers,

Peter.
