Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096Ab0KQWOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:14:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58598 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610Ab0KQWOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:14:49 -0500
Date: Wed, 17 Nov 2010 14:14:43 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Security] proactive defense: using read-only memory
Message-ID: <20101117221443.GR13854@outflux.net>
References: <20101107193520.GO5327@outflux.net>
 <20101117100053.GA1574@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117100053.GA1574@ucw.cz>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Nov 17, 2010 at 11:00:54AM +0100, Pavel Machek wrote:
> > - Modules need to be correctly marked RO/NX. This patch exists[3], but is
> >   not in mainline. It needs to be in mainline.
> 
> Why not.

That was answered in another thread: basically, it was side-tracked, but
has been recently re-proposed.

> > - Pointers to function table also need to be marked read-only after
> >   they are set. An example of this is the security_ops table pointer. It
> >   gets set once at boot, and never changes again. These need to be handled
> >   so it isn't possible to just trivially reaim the entire security_ops
> >   table lookup somewhere else.
> 
> But there are too many of those. You can't block them all...

Well, I don't think "too many" is a good reason. And I think it is possible
to block them all if we're careful and diligent. Maybe I'm naive; we'll see.

> > - Entry points to set_kernel_text_rw() and similar need to be blockable.
> >   Having these symbols available make kernel memory modification trivial;
> 
> What prevents attacker to just inlining those functions in the
> exploit?

The goal is to make it harder for an attacker to create, change, or hide
kernel code in memory. If they're able to already execute arbitrary code,
then yes, it's doesn't change anything. But the point is to make it harder
to get to that point to start with.

> If you want protection domain inside kernel, perhaps you should take
> ukernel approach?

Someone might want to, but I'm not interested in that. It's not impossible
to make the existing kernel more resilient to attack.

-Kees

-- 
Kees Cook
Ubuntu Security Team
