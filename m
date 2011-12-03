Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1LCMUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 07:20:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38798 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab1LCMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 07:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111203092845.GA1520@x4.trippels.de>
References: <20111121080554.GB1625@x4.trippels.de>
	<20111121082445.GD1625@x4.trippels.de>
	<1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111121131531.GA1679@x4.trippels.de>
	<1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111121153621.GA1678@x4.trippels.de>
	<20111123160353.GA1673@x4.trippels.de>
	<alpine.DEB.2.00.1111231004490.17317@router.home>
	<20111124085040.GA1677@x4.trippels.de>
	<20111202230412.GB12057@homer.localdomain>
	<20111203092845.GA1520@x4.trippels.de>
Date: Sat, 3 Dec 2011 12:20:22 +0000
Message-ID: <CAPM=9tyjZc9waC_ZBygW9zh+Zq-Wb1X5Y6yfsCCMPYwpFVWOOg@mail.gmail.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Dave Airlie <airlied@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jerome Glisse <j.glisse@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Alex, Shi" <alex.shi@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>, tj@kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > > > FIX idr_layer_cache: Marking all objects used
>> > > >
>> > > > Yesterday I couldn't reproduce the issue at all. But today I've hit
>> > > > exactly the same spot again. (CCing the drm list)

If I had to guess it looks like 0 is getting written back to some
random page by the GPU maybe, it could be that the GPU is in some half
setup state at boot or on a reboot does it happen from a cold boot or
just warm boot or kexec?

Jerome, might be worth checking the ordering for when bus master gets
enabled or if we turn off the writeback producers before writeback is
enabled.

Dave.
