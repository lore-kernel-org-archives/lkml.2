Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2EDI4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:56:39 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:52403 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2EDI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:56:37 -0400
Date: Fri, 4 May 2012 10:56:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Artem Bityutskiy <dedekind1@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/2] Makefile: make sure KCFLAGS options are at the end
Message-ID: <20120504085635.GA13450@merkur.ravnborg.org>
References: <1336117355-21348-1-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336117355-21348-1-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 10:42:34AM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> When I build the kernel like this:
> 
> $ make W=1 KCFLAGS="-Wno-sign-compare"
> 
> the "-Wno-sign-compare" option is ignore. The reason is that we append gcc
> options associated with W=1 _after_ KCFLAGS, so W=1 overrides my KCFLAGS
> options. This patch tries to fix the issue by moving the "W=[123]" stiff
> from "scripts/Makefile.build" to the main Maikefile. This fixes the issue
> as well as this should be a small improvent because "scripts/Makefile.build"
> is parsed by make many times (I think for each file), bue we do not need
> to re-assign all the warnings stuff so many times - it is enough to do it
> only once.

Moving all the W=... support out of Makefile.build is a good thing,
as we really should do the evaluation only once.

But I detest that this is added to the top-level Makefile.
The top-level Makefile is full of all sort of strange stuff
already and very hard to navigate / update for this reason.

How about introducing a new file : scripts/Kbuild.config
This file should be included only _once_ from the top-level Makefile.
And it should contains all the trivial assignments to
CC, CFLAGS, etc...

Including exporting of variables so they a visible in sub-makes.

First step could be to move the W=... support, and then it could be
gradually extended.

Michal - any comments on this?

	Sam
