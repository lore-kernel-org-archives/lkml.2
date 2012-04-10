Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab2DJU1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:27:25 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:59258 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885Ab2DJU1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:27:24 -0400
Date: Tue, 10 Apr 2012 22:27:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v4 1/4] tools: Add Makefile.include
Message-ID: <20120410202721.GA28293@merkur.ravnborg.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org> <1334071240-28692-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334071240-28692-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav.

Some random comments as I really did not look at this
part of the patch-set before.

> +#
> +# Include saner warnings here, which can catch bugs:
> +#
> +EXTRA_WARNINGS := -Wformat
> +EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security

Two general comments - and I know this is just something you copied...
Why not use the += operator. The below looks like shell script syntax.
And we use the += operator in other places - at least in the kernel stuff.

AND WHY ALL THESE SCREAMING CAPITAL LETTERS?
I know Makefiles and scripts are full of them - but that does not help
the readability.

For kbuild I generally shifted to use:
- lower-case names for local stuff
- Upper case letters for global stuff - properly prefixed to avoid collisions
EXTRA_WARNINGS likely fall into the category global-stuff,
but then a local variable could still be usefull.

	Sam
