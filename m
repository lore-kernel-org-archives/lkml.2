Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab0HXXEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:04:39 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:37605 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933846Ab0HXXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:04:36 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1/82CMXSTH8MPYGtek+OjjQuYiYIE5oNQO8YSyx8A
	R5zTvgso3/mqOJ
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use
 wait_for_vblank_off()
From: Ivan Bulatovic <combuster@gmx.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-gfx@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <89k83a$9drtkt@azsmga001.ch.intel.com>
References: <1282647815.2221.15.camel@localhost.localdomain>
	 <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk>
	 <1282684130.2199.25.camel@localhost.localdomain>
	 <89k83a$9drtkt@azsmga001.ch.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 01:04:31 +0200
Message-ID: <1282691071.2120.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 22:52 +0100, Chris Wilson wrote: 
> On Tue, 24 Aug 2010 23:08:50 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> > Unfotunately I still get TV connection detected :(
> 
> Jesse spotted the root cause and Linus has now pushed that fix for
> intel_wait_for_vblank() out. This is just a very minor bug in comparison.
> Can you please test against linus/master and check that resolves the
> spurious TV detection for you?
> Thanks.
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Spurious TV detection is still here and + I have a new problem with
resolution in init3 when KMS fires up, it occupies only 1/3rd of the
screen when booting.

I've tried patching the kernel I used for testing so far with that one
liner and I've tried without patches we tried so far (git pull on a
clean linux-git) and the symptoms are the same on both of them.

So
- PIPE_VBLANK_INTERRUPT_STATUS) == 0,
+ PIPE_VBLANK_INTERRUPT_STATUS),
in intel_display.c doesn't fix the issue, plus it brings a new one in my
case.


