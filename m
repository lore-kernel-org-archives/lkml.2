Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2KIRC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:02:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37368 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2KIRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <5099B150.7070808@firmworks.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <50999145.2070306@wwwdotorg.org> <5099B150.7070808@firmworks.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 17:02:05 +0000
X-Google-Sender-Auth: 94hEFzZ2g0kBxkeuZbN_2ZjuPwQ
Message-ID: <CACxGe6vTJHvZwZ383DE5-k+ksv1nGeuLynADuQC+D2eySj7gWQ@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Mitch Bradley <wmb@firmworks.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 12:54 AM, Mitch Bradley <wmb@firmworks.com> wrote:
> On 11/6/2012 12:37 PM, Stephen Warren wrote:
>> This proposal is very oriented at an overlay-based approach. I'm not
>> totally convinced that a pure overlay approach (as in how dtc does
>> overlayed DT nodes) will be flexible enough, but would love to be
>> persuaded. Again see below.
>
>
> An overlay approach will not be powerful enough to solve the sorts of
> problems that occur when a product goes into full production, becomes a
> family, and starts to evolve.  Issues like second-source parts that
> aren't quite compatible and need to be detected and reported,
> board-stuff options for different customer profiles, speed grades of
> parts that aren't properly probeable but instead need to be identified
> by some subterfuge, the list of tedious issues goes on and on.
>
> It's nice to pretend that the world fits into a few coherent simple
> use cases, but 30 years of experience shipping computer product families
> proves otherwise.  You need a programming language to solve the full
> set of problems - which I why the device tree is designed so it can
> be generated and modified by a program.

I'm not going to argue with that. There is nothing saying that the
overlay wouldn't be generated or applied by a script. However, I do
strongly think that the data model needs to be independent of any tool
or execution environment used to manipulate it. I certainly am not
interested in encoding scripts or bytecode into the tree - the
opposite of the approach used by ACPI which must execute AML to even
retrieve the device tree. I like the overlay approach because it is
conceptually straightforward and provides a working model of how
changes could be made from userspace while still being usable by
firmware.

An alternate approach from userspace would be to use a live virtual
filesystem to manipulate the device tree, though that approach only
applies to Linux userspace. Firmware would still need its own
approach.

g.
