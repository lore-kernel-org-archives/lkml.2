Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0CXV7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:59:05 -0400
Received: from gw1.transmode.se ([213.115.205.20]:41073 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab0CXV7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:59:00 -0400
In-Reply-To: <4BAA5F99.3050904@caviumnetworks.com>
References: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>	 <20100324112106.c8e7b96d.akpm@linux-foundation.org> <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com> <4BAA5F99.3050904@caviumnetworks.com>
Subject: Re: [PATCH] [RFC] #define __BYTE_ORDER
X-KeepSent: 8EC0683A:3FFD71B5-C12576F0:0077A6F3;
 type=4; name=$KeepSent
To: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OF8EC0683A.3FFD71B5-ONC12576F0.0077A6F3-C12576F0.00786611@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 24 Mar 2010 22:55:04 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-03-24 22:58:59
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Daney <ddaney@caviumnetworks.com> wrote on 2010/03/24 19:53:13:
>
> On 03/24/2010 11:37 AM, Geert Uytterhoeven wrote:
> > On Wed, Mar 24, 2010 at 19:21, Andrew Morton<akpm@linux-foundation.org>  wrote:
> >> On Wed, 17 Mar 2010 19:10:55 +0100
> >> Joakim Tjernlund<Joakim.Tjernlund@transmode.se>  wrote:
> >>
> >>> Linux does not define __BYTE_ORDER in its endian header files
> >>> which makes some header files bend backwards to get at the
> >>> current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
> >>> to make it easier for header files that are used in user space too.
> >>
> >> I don't get it.  Why not nuke __BYTE_ORDER altogether and do `#ifdef
> >> __LITTLE_ENDIAN' and `#ifdef __BIG_ENDIAN' everywhere?
> >
> > Because in userspace the convention is that
> >    1. _both_ __LITTLE_ENDIAN and __BIG_ENDIAN are defined,
> >    2. you have to test for e.g. __BYTE_ORDER == __BIG_ENDIAN.
> >
>
> I have stumbled on this issue as well.
>
> However, consider this:
>
> If you make such a change, then you will start to see:
>
> #if __BYTE_ORDER == __BIG_ENDIAN
>
> appearing in kernel source code.  Do we want two different endian
> checking idioms in the kernel?  Or would it be just a single idiom, but
> one that is different than the status quo?

>From my patch you already see that there some ugliness in header files because
one wants to use them in user space too. I don't think inventing a kernel
specific idiom will by us anything. To keep the confusion down it is
better to just use #if __BYTE_ORDER == __BIG_ENDIAN all over.

>
> The only time I can see that it makes a difference is if you want to
> share things like driver source code files between in-kernel drivers and
> userspace.  A discussion of which, would probably provoke much discussion.

Yes, I stumbled over this when I moved crc32.c to run the test routine
included in there. Took me quite a while to figure out what was wrong
because you don't even get a warning, it just silently breaks.

