Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2IXMYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:24:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2IXMYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:24:51 -0400
Message-ID: <1348489478.11847.55.camel@twins>
Subject: Re: [PATCH 2/2] [RESEND] console: implement lockdep support for
 console_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 24 Sep 2012 14:24:38 +0200
In-Reply-To: <1348489027.11847.53.camel@twins>
References: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch>
	 <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
	 <1348489027.11847.53.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 14:17 +0200, Peter Zijlstra wrote:
> On Tue, 2012-09-18 at 01:03 +0200, Daniel Vetter wrote:
> > - In the printk code there's a special trylock, only used to kick off
> >   the logbuffer printk'ing in console_unlock. But all that happens
> >   while lockdep is disable (since printk does a few other evil
> >   tricks). So no issue there, either. 
> 
> Not particularly evil, just plain broken.
> 
> See this series:
> 
>   http://marc.info/?l=linux-kernel&m=132446644123326&w=2
> 
> In particular see patches 1-4. The problem with lockdep is that lockdep
> uses printk and printk's recursion stuff is utterly broken.
> 
> Console drivers being on crack simply doesn't help :-) Note that I would
> never recommend drm/ksm to anybody who really cares about their console
> output.

Also, don't cross-post with a subscribe only list.
