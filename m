Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2KUQoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:44:13 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50701 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab2KUQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:44:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>
In-Reply-To: <20121121013133.GE4673@opensource.wolfsonmicro.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost> <20121121013133.GE4673@opensource.wolfsonmicro.com>
Date: Wed, 21 Nov 2012 16:44:04 +0000
Message-Id: <20121121164404.E04EF3E0AE2@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 10:31:34 +0900, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 20, 2012 at 09:54:29PM +0000, Grant Likely wrote:
> > On Sat, 17 Nov 2012 19:55:45 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > > With the advent of the device tree and of ARM kernels that are not
> > > board-tied, we cannot rely on these board-specific hooks anymore but
> 
> > This isn't strictly true. It is still perfectly fine to have board
> > specific code when necessary. However, there is strong encouragement to
> > enable that code in device drivers as much as possible and new board
> > files need to have very strong justification.
> 
> This isn't the message that's gone over, and even for device drivers
> everyone seems to be taking the whole device tree thing as a move to
> pull all data out of the kernel.  In some cases there are some real
> practical advantages to doing this but a lot of the people making these
> changes seem to view having things in DT as a goal in itself.

I know, and I do apologize for my part in not communicating and
shepherding enough. For anyone reading; please be pragmatic on putting
things into the DT. If a binding starts to look really complex, ask
whether or not it helps things.

> > I'm thinking about the scripts as trivial-to-parse ascii strings that
> > have a very simple set of commands. The commands use resources already
> > defined in the node. ie. 'g0' refers to the first entry in the gpios
> > property. 'r0' for the regulator, 'p0' for the pwms, 'd' means delay. By
> > no means take this as the format to use, it is just an example off the
> > top of my head, but it is already way easier to work with than putting
> > each command into a node.
> 
> It does appear to have some legibility challenges, especially with using
> the indexes into the arrays of resources.  On the other hand the arrays
> should be fairly small.

This is merely an example off the top of my head. I'm in no way wed to
the syntax.

> > > +Platform Data Format
> > > +--------------------
> > > +All relevant data structures for declaring power sequences are located in
> > > +include/linux/power_seq.h.
> 
> > Hmm... If sequences are switched to a string instead, then platform_data
> > should also use it. The power sequence data structures can be created at
> > runtime by parsing the string.
> 
> Seems like a step backwards to me - why not let people store the more
> parsed version of the data?  It's going to be less convenient for users
> on non-DT systems.
> 
> As I said in my earlier reviews I think this is a useful thing to have
> as a utility library for drivers independantly of the DT bindings, it
> would allow drivers to become more data driven.  Perhaps we can rework
> the series so that the DT bindings are added as a final patch?  All the
> rest of the code seems OK.

I'm fine with that if the bindings don't get merged yet.

g.

