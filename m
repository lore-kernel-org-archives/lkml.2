Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1H0QfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 12:35:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12024 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1H0QfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 12:35:12 -0400
Date: Sat, 27 Aug 2011 18:36:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andi Kleen <andi@firstfloor.org>
cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
In-Reply-To: <20110826222544.GV25996@one.firstfloor.org>
Message-ID: <alpine.LNX.2.00.1108271829590.27813@swampdragon.chaosbits.net>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <20110826214329.GA6325@kroah.com> <20110826222544.GV25996@one.firstfloor.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Aug 2011, Andi Kleen wrote:

> > > wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> > > gcc -o uname26 uname26.c
> > > ./uname26 program
> > 
> > I hate to ask, but can you put a proper copyright and license on this
> > file so that distros can distribute it?
> 
> I assumed it's too trivial for that.
> 
> Anyways I put a GPL license on it now.
> 

Hi Andi

I assume the mention of "mcelog" is a cut'n'paste error and that it really 
should have been "uname26", so here's a trivial patch to correct that.
I also deleted all trailing whitespace and used EXIT_FAILURE rather than 1 
for exit().

Take it or leave it :)

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

--- uname26.c.orig	2011-08-27 18:26:46.538017670 +0200
+++ uname26.c	2011-08-27 18:32:21.032163525 +0200
@@ -1,19 +1,19 @@
-/* Copyright (C) 2011 Intel Corporation 
+/* Copyright (C) 2011 Intel Corporation
    Author: Andi Kleen
    Set 2.6.x personality
 
-   mcelog is free software; you can redistribute it and/or
+   uname26 is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public
    License as published by the Free Software Foundation; version
    2.
 
-   mcelog is distributed in the hope that it will be useful,
+   uname26 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.
 
    You should find a copy of v2 of the GNU General Public License somewhere
-   on your Linux system; if not, write to the Free Software Foundation, 
+   on your Linux system; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA */
 #include <sys/personality.h>
 #include <stdio.h>
@@ -26,15 +26,15 @@
 
 int main(int ac, char **av)
 {
-	if (!av[1]) { 
+	if (!av[1]) {
 		fprintf(stderr, "Usage: uname26 program ...\n"
 				"Run program with the uname 2.6 personality\n");
-		exit(1);
+		exit(EXIT_FAILURE);
 	}
 	if (personality(PER_LINUX | UNAME26) < 0)
 		perror("personality"), exit(1);
-	
+
 	execvp(av[1], av + 1);
 	fprintf(stderr, "Cannot execute %s: %s\n", av[1], strerror(errno));
-	exit(1);
+	exit(EXIT_FAILURE);
 }


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

