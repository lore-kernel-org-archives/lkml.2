Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2IXMRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:17:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:37394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2IXMRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:17:17 -0400
Message-ID: <1348489027.11847.53.camel@twins>
Subject: Re: [PATCH 2/2] [RESEND] console: implement lockdep support for
 console_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 24 Sep 2012 14:17:07 +0200
In-Reply-To: <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch>
	 <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 01:03 +0200, Daniel Vetter wrote:
> - In the printk code there's a special trylock, only used to kick off
>   the logbuffer printk'ing in console_unlock. But all that happens
>   while lockdep is disable (since printk does a few other evil
>   tricks). So no issue there, either. 

Not particularly evil, just plain broken.

See this series:

  http://marc.info/?l=linux-kernel&m=132446644123326&w=2

In particular see patches 1-4. The problem with lockdep is that lockdep
uses printk and printk's recursion stuff is utterly broken.

Console drivers being on crack simply doesn't help :-) Note that I would
never recommend drm/ksm to anybody who really cares about their console
output.
