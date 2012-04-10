Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2DJU7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:59:03 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40617 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385Ab2DJU7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:59:01 -0400
Date: Tue, 10 Apr 2012 22:58:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v4 1/4] tools: Add Makefile.include
Message-ID: <20120410205849.GB30366@aftab>
References: <1334071240-28692-1-git-send-email-bp@amd64.org>
 <1334071240-28692-2-git-send-email-bp@amd64.org>
 <20120410202721.GA28293@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410202721.GA28293@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:27:21PM +0200, Sam Ravnborg wrote:
> Hi Borislav.
> 
> Some random comments as I really did not look at this
> part of the patch-set before.

.. and I appreciate those, thanks.

> > +#
> > +# Include saner warnings here, which can catch bugs:
> > +#
> > +EXTRA_WARNINGS := -Wformat
> > +EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
> 
> Two general comments - and I know this is just something you copied...

Yep, I did from perf's Makefile.

> Why not use the += operator. The below looks like shell script syntax.
> And we use the += operator in other places - at least in the kernel stuff.

Yep, this makes this assignment monster a bit more readable, sure.

> AND WHY ALL THESE SCREAMING CAPITAL LETTERS?
> I know Makefiles and scripts are full of them - but that does not help
> the readability.
> 
> For kbuild I generally shifted to use:
> - lower-case names for local stuff
> - Upper case letters for global stuff - properly prefixed to avoid collisions
> EXTRA_WARNINGS likely fall into the category global-stuff,
> but then a local variable could still be usefull.

Well, my intention was to have EXTRA_WARNINGS be a global variable which
all tools under tools/ could start using so that we can benefit from the
compiler doing some more extensive checking. Thus all caps, no?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
