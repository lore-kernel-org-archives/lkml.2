Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1ADOET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:04:19 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33122 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342Ab1ADOES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:04:18 -0500
Date: Tue, 4 Jan 2011 15:03:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0] add nano semaphore in kernel
Message-ID: <20110104140355.GA1707@ucw.cz>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +/*
> + * nano_semaphore_down - acquire the nano semaphore
> + * @s: the nano semaphore to be acquired
> + * @nano_secs: the nano seconds to wait if necessary,
> + *		could be zero if want to wait as long as possible.
> + *
> + * Returns >0 if acquired successfully, <=0 otherwise.
> + *
> + * Note unlike down() in semaphore, nano_semaphore_down is not looping until
> + * the nano semaphore is hold, but simply reports the result. And the callers
> + * could, if they like, loop in simple manner, for instance,
> + *	while (1 != nano_semaphore_down(s, 800));
> + *	do_home_work();
> + *	nano_semaphore_up(s);

But thats spinlock, not semaphore, right?

Also, your example does not use the API right -- according to
description, 42 is correct 'semaphore acquired' reply...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
