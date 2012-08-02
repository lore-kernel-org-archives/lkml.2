Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2HBWQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:16:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2HBWQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:16:30 -0400
Date: Fri, 3 Aug 2012 00:16:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc64: do not clobber personality flags in
 sys_sparc64_personality()
In-Reply-To: <20120802161917.GA5493@merkur.ravnborg.org>
Message-ID: <alpine.LNX.2.00.1208030014410.4820@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012204140.14910@pobox.suse.cz> <alpine.LNX.2.00.1208020912130.14910@pobox.suse.cz> <20120802161917.GA5493@merkur.ravnborg.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, Sam Ravnborg wrote:

> > >From 4f000eda5917ceecb03767962026cc6a390b8216 Mon Sep 17 00:00:00 2001
> > From: Jiri Kosina <jkosina@suse.cz>
> > Date: Wed, 1 Aug 2012 21:10:51 +0200
> > Subject: [PATCH 4/4] sparc64: do not clobber personality flags in sys_sparc64_personality()
> > 
> > There are multiple errors in how sys_sparc64_personality() handles
> > personality flags stored in top three bytes.
> > 
> > - directly comparing current->personality against PER_LINUX32 doesn't work
> >   in cases when any of the personality flags stored in the top three bytes
> >   are used.
> > - directly forcefully setting personality to PER_LINUX32 or PER_LINUX
> >   discards any flags stored in the top three bytes
> > 
> > Fix the first one by properly using personality() macro to compare only
> > PER_MASK bytes.
> > Fix the second one by setting only the bits that should be set, instead of
> > overwriting the whole value.
> 
> Hi Jiri.
> 
> Can you have a quick look at this too:
> arch/sparc/include/asm/elf_32.h:#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
> 
> From your other comments it looks wrong. But I have not digged into 
> this.

It actually seems like much more architectures than just sparc are 
clobbering upper bytes of personality upon exec(). Thanks for pointing 
that out, it'd be worthwile to go over those and fix them up. I am adding 
that to my TODO.

Thanks,

-- 
Jiri Kosina
SUSE Labs
