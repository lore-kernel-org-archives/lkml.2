Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1HODmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:42:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36121 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1HODmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:42:32 -0400
Subject: Re: [BUG] Linux 3.0 commit 3627924acf70a broke
 include/mtd/ubi_user.h.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rob Landley <rob@landley.net>
Cc: Michal Marek <mmarek@suse.cz>, "Adrian.Hunter" <Adrian.Hunter@intel.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, busybox@busybox.net
Date: Mon, 15 Aug 2011 06:42:27 +0300
In-Reply-To: <1313379564.2200.9.camel@koala>
References: <4E4809BF.6040707@landley.net> <20110814200322.3fa7109d@stein>
	 <4E481F0D.3090404@landley.net> <1313379564.2200.9.camel@koala>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1313379749.2200.11.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 06:39 +0300, Artem Bityutskiy wrote:
> On Sun, 2011-08-14 at 14:16 -0500, Rob Landley wrote:
> > On 08/14/2011 01:03 PM, Stefan Richter wrote:
> > > On Aug 14 Rob Landley wrote:
> > >> "make headers_install" copies include/mtd/ubi_user.h to userspace, where
> > >> things like busybox link against it.  With 3.0, building defconfig
> > >> busybox gets this error:
> > >>
> > >> In file included from miscutils/ubi_tools.c:63:
> > >> /home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:329:
> > >> error: conflicting types for '__packed'
> > >> /home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:313:
> > >> error: previous declaration of '__packed' was here
> > >>
> > >> This is due to the Linux 3.0 commit in the title:
> > >>
> > >>     UBI: use __packed instead of __attribute__((packed))
> > >>
> > >> This relies on __packed being defined in:
> > >>
> > >>   include/linux/compiler-gcc.h:
> > >>   #define __packed			__attribute__((packed))
> > >>
> > >> Which is not exported to userspace.
> > >>
> > >> I.E. this "cleanup" broke the ability for userspace to use this header,
> > >> even though the header is exported to userspace by headers_install.
> > > 
> > > As far as I can tell, the __packed or __attribute__((packed))
> > > qualifications are superfluous in include/mtd/ubi-user.h anyway.
> > 
> > And Adrian Hunter <adrian.hunter@nokia.com> (the other listed UBI
> > maintainer) also bounces.  Did the developer exodus after Nokia decided
> > to cozy up to The Black Widow take 'em both out?
> 
> Yes, both of us have left Nokia recently. Adrian should fix the
> "MAINTAINERS" file.
> 
> WRT to the breakage - yes, it was my mistake to follow the new trend in
> the Linux kernel - the commit message has a reference to the other
> commit which inspired the check, and you can find out that some other
> projects made a similar change. Moreover, checkpatch.pl prints the
> following warning "WARN("__packed is preferred over
> __attribute__((packed))". So you hardly can blame :-)
> 
> Anyways, this problem was discussed in the "__packed vs.
> __attribute__((packed)) in kernel headers" thread in LKML.
> 
> Then a fix has been sent, see the "{PATCH] fix __packed in exported
> kernel headers" thread in LKML. This fix was accepted by "Michal Marek
> <mmarek@suse.cz>", whom I put to CC.

And the fix is upstream, see:

commit f210735fe2f17a6225432ee3d1239bcf23a8659c
Author: Markus Trippelsdorf <markus@trippelsdorf.de>
Date:   Fri Jun 24 15:51:00 2011 +0200

Probably someone can ping the -stable team and ask them to take it to
linux-3.0-stable?

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

