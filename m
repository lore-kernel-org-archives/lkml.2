Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1DUVRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:17:14 -0400
Received: from mail.perches.com ([173.55.12.10]:4892 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab1DUVRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:17:12 -0400
Subject: Re: [PATCH] kbuild: fix W=1 with gcc 4.3.2
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
In-Reply-To: <1303420403.2784.25.camel@edumazet-laptop>
References: <20110421210852.GA6196@merkur.ravnborg.org>
	 <1303420403.2784.25.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 14:17:11 -0700
Message-ID: <1303420631.24766.87.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 23:13 +0200, Eric Dumazet wrote:
> Le jeudi 21 avril 2011 à 23:08 +0200, Sam Ravnborg a écrit :
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
[]
> > index d5f925a..b280284 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -73,7 +73,7 @@ KBUILD_EXTRA_WARNINGS += -Wnested-externs
> >  KBUILD_EXTRA_WARNINGS += -Wold-style-definition
> >  KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
> >  KBUILD_EXTRA_WARNINGS += -Wpacked
> > -KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
> > +KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wpacked-bitfield-compat)
> >  KBUILD_EXTRA_WARNINGS += -Wpadded
> >  KBUILD_EXTRA_WARNINGS += -Wpointer-arith
> >  KBUILD_EXTRA_WARNINGS += -Wredundant-decls
> > --
> Please add same fix for gcc-4.1.2
> cc1: error: unrecognized command line option "-Wlogical-op"

Maybe it'd be easier if all of these were
$(call cc-option, ...)


