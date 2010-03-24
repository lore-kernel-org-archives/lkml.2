Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab0CXSvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:51:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932276Ab0CXSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:51:32 -0400
Date: Wed, 24 Mar 2010 11:51:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] #define __BYTE_ORDER
Message-Id: <20100324115112.07ce4807.akpm@linux-foundation.org>
In-Reply-To: <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
References: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>
	<20100324112106.c8e7b96d.akpm@linux-foundation.org>
	<10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 19:37:36 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Wed, Mar 24, 2010 at 19:21, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 17 Mar 2010 19:10:55 +0100
> > Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:
> >
> >> Linux does not define __BYTE_ORDER in its endian header files
> >> which makes some header files bend backwards to get at the
> >> current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
> >> to make it easier for header files that are used in user space too.
> >
> > I don't get it. __Why not nuke __BYTE_ORDER altogether and do `#ifdef
> > __LITTLE_ENDIAN' and `#ifdef __BIG_ENDIAN' everywhere?
> 
> Because in userspace the convention is that
>   1. _both_ __LITTLE_ENDIAN and __BIG_ENDIAN are defined,
>   2. you have to test for e.g. __BYTE_ORDER == __BIG_ENDIAN.

umph.  We don't _have_ to copy userspace, and removing __BYTE_ORDER
altogether makes the kernel cleaner and simpler.

But if we did that, we shouldn't have used the same symbols as
userspace.  Sigh.

