Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1FXRBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:01:31 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:46592 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FXRB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:01:29 -0400
Date: Fri, 24 Jun 2011 19:01:26 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
Message-ID: <20110624170126.GC1708@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
 <4E048C0D.7020403@suse.cz>
 <20110624135100.GB1708@x4.trippels.de>
 <201106241833.15424.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201106241833.15424.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.24 at 18:33 +0200, Arnd Bergmann wrote:
> On Friday 24 June 2011, Markus Trippelsdorf wrote:
> > checkpatch.pl warns about using __attribute__((packed)) in kernel
> > headers: "__packed is preferred over __attribute__((packed))". If one
> > follows that advice it could cause problems in the exported header
> > files, because the outside world doesn't know about this shortcut.
> > 
> > For example busybox will fail to compile:
> >  CC      miscutils/ubi_attach_detach.o
> >  In file included from miscutils/ubi_attach_detach.c:27:0:
> >  /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
> >  /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> > ...
> > 
> > Fix the problem by substituting __packed with __attribute__((packed)) in
> > the header_install.pl script.
> 
> No objections to the patch, but it should probably be noted that user
> visible data structures should ideally not have any attributes, because
> that requires building all applictions using that interface with gcc.
> 
> We generally try to add no such requirements on user applications.

Both icc and clang support __attribute__((packed)).

And a rough count shows:
% grep -R "packed" /usr/src/linux/usr/include | wc -l
262

-- 
Markus
