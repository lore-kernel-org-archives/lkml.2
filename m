Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab1EBEC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 00:02:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1EBEC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 00:02:27 -0400
Date: Mon, 2 May 2011 00:02:16 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-ID: <20110502040216.GC11804@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
 <20110502022417.GA11804@redhat.com>
 <20110502134524.40da4245.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502134524.40da4245.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:45:24PM +1000, Stephen Rothwell wrote:

 > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
 > index 9c0c481..9fb19c0 100644
 > --- a/scripts/Makefile.build
 > +++ b/scripts/Makefile.build
 > @@ -66,6 +66,7 @@ warning-1 += -Wmissing-format-attribute
 >  warning-1 += -Wmissing-prototypes
 >  warning-1 += -Wold-style-definition
 >  warning-1 += $(call cc-option, -Wmissing-include-dirs)
 > +warning-1 += $(call cc-option, -Wunused-but-set-variable)

Subtly different from what I wrote.. the version I wrote did this ..

+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wunused-but-set-variable)

I just tested with the gcc 4.4.5 on master.kernel.org, with a tip of Linus'
tree with my original diff, and it didn't complain at all. 
What does gcc -v say ?
gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC)  seems to be fine.

(note the above hunk isn't relevant unless using W=1 builds anyway,
so I'm at a loss as to what broke it..)

	Dave

