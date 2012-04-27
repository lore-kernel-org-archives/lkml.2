Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188Ab2D0Sef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:34:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761145Ab2D0See (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:34:34 -0400
Date: Fri, 27 Apr 2012 14:34:02 -0400 (EDT)
Message-Id: <20120427.143402.1028957981042061092.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
References: <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com>
	<4F9A6ABA.6050503@msgid.tls.msk.ru>
	<CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 11:34:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:19:13 -0700

> So to me, a version 6 with just this fix is just completely pointless.
> We can't just ignore existing binaries. You don't like ignoring
> existing 'automount' binaries, and Thomas doesn't like ignoring
> existing 'systemd' binaries. And I don't like ignoring *any* binaries
> that are shipped with distributions - especially when they are central
> and hard to work around.

I think what we did was break a kernel exported interface which had
5 years of precedence.  Ugly, or broken, it was the state of affairs
and userland did embrace it. :-)

If systemd wants to use version 5 of this thing, it has to have the
same workaround code automountd has.  It is systemd (and now the
kernel) which is broken.

We should have never touched version 5 of the data-structure.  Having
5 years of workaround precedence in userspace proves this.

And we should create a version 6 as has been proposed.
