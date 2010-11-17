Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab0KQKBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:01:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55345 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932745Ab0KQKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:01:07 -0500
Date: Wed, 17 Nov 2010 11:00:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Security] proactive defense: using read-only memory
Message-ID: <20101117100053.GA1574@ucw.cz>
References: <20101107193520.GO5327@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107193520.GO5327@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> - Modules need to be correctly marked RO/NX. This patch exists[3], but is
>   not in mainline. It needs to be in mainline.

Why not.

> - Pointers to function table also need to be marked read-only after
>   they are set. An example of this is the security_ops table pointer. It
>   gets set once at boot, and never changes again. These need to be handled
>   so it isn't possible to just trivially reaim the entire security_ops
>   table lookup somewhere else.

But there are too many of those. You can't block them all...

> - Entry points to set_kernel_text_rw() and similar need to be blockable.
>   Having these symbols available make kernel memory modification trivial;

What prevents attacker to just inlining those functions in the
exploit?

If you want protection domain inside kernel, perhaps you should take
ukernel approach?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
