Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0CXVtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:49:05 -0400
Received: from gw1.transmode.se ([213.115.205.20]:40219 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0CXVtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:49:00 -0400
In-Reply-To: <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
References: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>	 <20100324112106.c8e7b96d.akpm@linux-foundation.org> <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
Subject: Re: [PATCH] [RFC] #define __BYTE_ORDER
X-KeepSent: CDA39D22:62EC6456-C12576F0:00770DDD;
 type=4; name=$KeepSent
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, geert.uytterhoeven@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFCDA39D22.62EC6456-ONC12576F0.00770DDD-C12576F0.00778EFD@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 24 Mar 2010 22:45:53 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-03-24 22:48:58
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

geert.uytterhoeven@gmail.com wrote on 2010/03/24 19:37:36:
>
> On Wed, Mar 24, 2010 at 19:21, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 17 Mar 2010 19:10:55 +0100
> > Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:
> >
> >> Linux does not define __BYTE_ORDER in its endian header files
> >> which makes some header files bend backwards to get at the
> >> current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
> >> to make it easier for header files that are used in user space too.
> >
> > I don't get it.  Why not nuke __BYTE_ORDER altogether and do `#ifdef
> > __LITTLE_ENDIAN' and `#ifdef __BIG_ENDIAN' everywhere?
>
> Because in userspace the convention is that
>   1. _both_ __LITTLE_ENDIAN and __BIG_ENDIAN are defined,
>   2. you have to test for e.g. __BYTE_ORDER == __BIG_ENDIAN.

Precisely, I see that i forgot to mention that in the commit msg.

It is actually worse that that, gcc will only define one of __LITTLE_ENDIAN/__BIG_ENDIAN
so you might be tricked that using just the __LITTLE_ENDIAN/__BIG_ENDIAN defines works.
Then you add some include file such as stdlib.h and it all breaks because now
both __LITTLE_ENDIAN and __BIG_ENDIAN are defined.

 Jocke

