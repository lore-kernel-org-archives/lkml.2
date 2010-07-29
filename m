Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0G2S2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:28:43 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:56005 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754742Ab0G2S2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:28:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lXmcfiEtnV9MvSIDNdZC1LkJK9Rh9w4Ut/6ivpHCQSSTU8HiENYC+7fBZXv95vNiv5tlhyQCV3AU2pi5iEmDXcjZgY5TaaRoAAlQ72T/rpBoykD228xU/NrwcMZnaKeq;
Date: Thu, 29 Jul 2010 11:28:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kan-Ru Chen <kanru@kanru.info>
Cc: Enrico Bandiello <enban@postal.uv.es>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Enrico Bandiello <enban@alumni.uv.es>
Subject: Re: [Bug #16307] i915 in kernel 2.6.35-rc3, high number of wakeups
Message-ID: <20100729112837.0d010cc7@virtuousgeek.org>
In-Reply-To: <87sk38b7ai.fsf@anar.kanru.info>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
	<tneGvaw1wLL.A.mXB.p3XSMB@chimera>
	<20100723102532.6bfade32@virtuousgeek.org>
	<4C4AB036.3060003@postal.uv.es>
	<87sk38b7ai.fsf@anar.kanru.info>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jul 2010 10:54:13 +0800
Kan-Ru Chen <kanru@kanru.info> wrote:

> Hi,
> 
> On Sat, 24 Jul 2010 11:19:50 +0200, Enrico Bandiello <enban@postal.uv.es> wrote:
> > On 07/23/2010 07:25 PM, Jesse Barnes wrote:
> > > On Fri, 23 Jul 2010 13:47:31 +0200 (CEST)
> > > "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
> > >
> > >> This message has been generated automatically as a part of a summary report
> > >> of recent regressions.
> > >>
> > >> The following bug entry is on the current list of known regressions
> > >> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > >> know (either way).
> > >>
> > >>
> > >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16307
> > >> Subject		: i915 in kernel 2.6.35-rc3, high number of wakeups
> > >> Submitter	: Enrico Bandiello<enban@postal.uv.es>
> > >> Date		: 2010-06-26 16:57 (28 days old)
> > >> Message-ID	:<4C26317A.5070309@postal.uv.es>
> > >> References	: http://marc.info/?l=linux-kernel&m=127757403404259&w=2
> > >
> > > Just updated the bug for this one.  Enrico, you say this behavior is
> > > recent.  Can you bisect between 2.6.34 and when the problem started?
> > >
> > Hi. I just tried, but can't find anything useful until now (surely it's 
> > my fault: it was my first attempt at bisection). Please let me try again 
> > in the next days.
> 
> I also noticed that interrupts keeps high in powertop. I bisected it
> today:
> 
> # bad: [e44a21b7268a022c7749f521c06214145bd161e4] Linux 2.6.35-rc2
> # good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
> git bisect start 'v2.6.35-rc2' 'v2.6.34'
> # good: [2086ca482f89950410527425913ca48d948e9622] i2c-algo-pca: Fix coding style issues
> git bisect good 2086ca482f89950410527425913ca48d948e9622
> # bad: [1756ac3d3c41341297ea25b818b7fce505bb2a9a] Merge branch 'virtio' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
> git bisect bad 1756ac3d3c41341297ea25b818b7fce505bb2a9a
> # bad: [ec2a7587e0a91d5c1afe23a0a73edfce06c5e4e0] Merge branch 'msm-video' of git://codeaurora.org/quic/kernel/dwalker/linux-msm
> git bisect bad ec2a7587e0a91d5c1afe23a0a73edfce06c5e4e0
> # good: [e0bc5d4a54938eedcde14005210e6c08aa9727e4] Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
> git bisect good e0bc5d4a54938eedcde14005210e6c08aa9727e4
> # good: [ac3ee84c604502240122c47b52f0542ec8774f15] Merge branch 'dbg-early-merge' of git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb
> git bisect good ac3ee84c604502240122c47b52f0542ec8774f15
> # bad: [f4b7fb94c576265ceffc43031805ade32fa80c6a] drm/radeon/kms: take vram mutex pointer before derefing object.
> git bisect bad f4b7fb94c576265ceffc43031805ade32fa80c6a
> # bad: [0bcb1d844ac638a4c4280f697d5bfac9791e9a70] Merge branch 'drm-radeon-lockup' into drm-core-next
> git bisect bad 0bcb1d844ac638a4c4280f697d5bfac9791e9a70
> # bad: [77ffb5979de59efd1a6b280b10d647b09285bee0] drm/i915/pch: Use minimal number of FDI lanes (v2)
> git bisect bad 77ffb5979de59efd1a6b280b10d647b09285bee0
> # bad: [ab00a9ef8d4ce7de4d5b15cbf4101feeb8cf7f4d] drm/i915: Un-magic a DPCD register write
> git bisect bad ab00a9ef8d4ce7de4d5b15cbf4101feeb8cf7f4d
> # skip: [0f3ee801b332d6ff22285386675fe5aaedf035c3] drm/i915: Allow LVDS on pipe A on gen4+
> git bisect skip 0f3ee801b332d6ff22285386675fe5aaedf035c3
> # good: [5bf4c9c469ffc64b85fed1f3d2b0c8b19909ed13] drm/i915: use encoder_list for hotplug callback
> git bisect good 5bf4c9c469ffc64b85fed1f3d2b0c8b19909ed13
> # bad: [d275f6614e160fa71d6e2201eb34c9b41fd8473c] drm/i915: Clear the LVDS pipe B select bit when moving the LVDS to pipe A.
> git bisect bad d275f6614e160fa71d6e2201eb34c9b41fd8473c
> # good: [c1c43977e6fc789cbde094303fa9ace629a35aca] drm/i915: passing drm connector param for load detection
> git bisect good c1c43977e6fc789cbde094303fa9ace629a35aca
> # good: [6443170f6d862a1cc89e61e4bb2410b714b875f4] drm/i915: Remove dead KMS encoder save/restore code.
> git bisect good 6443170f6d862a1cc89e61e4bb2410b714b875f4
> 
> The bisect stopped between d275f66 and 0f3ee80 so I reverted the
> following three commits:
> 
> b3b095b drm/i915: enable LVDS on Cougarpoint
> d275f66 drm/i915: Clear the LVDS pipe B select bit when moving the LVDS to pipe A.
> 0f3ee80 drm/i915: Allow LVDS on pipe A on gen4+
> 
> Now the powertop only shows about 0.2 interrupts per second. Hope this
> information is useful.

Hm that doesn't make much sense.  Can you collect register dumps using
intel_reg_dumper between the two cases?  I'd expect the LVDS to be on
pipe b after the revert, but maybe before the revert we're leaving pipe
b enabled and getting spurious interrupts?

-- 
Jesse Barnes, Intel Open Source Technology Center
