Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056Ab1FADtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:49:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:33395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201Ab1FADtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:49:20 -0400
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.01.1105311959000.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
	 <1306887942.29297.10.camel@pasglop>
	 <alpine.DEB.2.01.1105311744000.21697@trent.utfs.org>
	 <alpine.DEB.2.01.1105311959000.21697@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:49:03 +1000
Message-ID: <1306900143.29297.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 20:02 -0700, Christian Kujau wrote:
> (Cc'in Linus)
> 
> On Tue, 31 May 2011 at 17:48, Christian Kujau wrote:
> > In the meantime, "git bisect" behaves kinda weird, I don't know what went 
> > wrong here:
> > 
> >  $ git bisect start
> >  $ git bisect good         # Linux 2.6.39
> >  $ git bisect bad v3.0-rc1 # Linux 3.0-rc1
> >  $ git bisect bad          # c44dead70a...
> >  $ git bisect bad          # d93515611b..
> > 
> > ...yet the ./Makefile shows[0] that I'm already way behind: 2.6.39-rc2. 
> > Maybe "git bisect" got confused with that whole 2.6.x -> 3.0 renaming?
> 
> Hm, I tried again, from a clean v3.0-rc1 (git reset --hard), but after the 
> 2nd "git bad" I'm at 2.6.39-rc2 again - while I /should/ be somwhere 
> inbetween v2.6.39..v3.0-rc1, right?

Kernel version is totally irrelevant when bisecting. You are not walking
through a linear series of patches but a complex tree of merges which
might have forked off different versions in the first place.

Cheers,
Ben.


