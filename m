Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1DUU4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:56:16 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47192 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1DUU4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:56:15 -0400
X-Greylist: delayed 91467 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 16:56:15 EDT
Date: Thu, 21 Apr 2011 22:56:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421205612.GA4541@merkur.ravnborg.org>
References: <20110421192117.GA14249@redhat.com> <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com> <4DB087EC.1010205@caviumnetworks.com> <1303415086.24766.84.camel@Joe-Laptop> <20110421195801.GA15126@redhat.com> <20110421200836.GA31709@merkur.ravnborg.org> <20110421202713.GA19425@redhat.com> <4DB09590.1040709@caviumnetworks.com> <20110421204549.GA20508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421204549.GA20508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 04:45:49PM -0400, Dave Jones wrote:
> On Thu, Apr 21, 2011 at 01:37:36PM -0700, David Daney wrote:
>  > > +KBUILD_EXTRA_WARNINGS += -Wunused-but-set-variable
>  > 
>  > Well I didn't test it, but presumably if you need the $(call cc-option, 
>  > -Wno-unused-but-set-variable), you would need similar here.
>  
> Third time's the charm ?

Seems soo. It semi works now.
"make W=1" is broken for reasons that is not related to this patch - will submit
a fix in a minute for that.

So you can add:
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>

on the patch.

And if you really want to make me happy then you add a comment about _why_
we disable the warning.

Something like:

# This warning generated too much noise in a regular build.
# Use make W=1 to enable this warning (see scripts/Makefile.build)
+KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+
 ifdef CONFIG_FRAME_POINTER


	Sam
