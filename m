Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab1FIW5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:57:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696Ab1FIW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:57:08 -0400
Date: Thu, 9 Jun 2011 15:56:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Message-Id: <20110609155630.0f734351.akpm@linux-foundation.org>
In-Reply-To: <1307642718-22257-1-git-send-email-minipli@googlemail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
	<1307642718-22257-1-git-send-email-minipli@googlemail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Jun 2011 20:05:18 +0200
Mathias Krause <minipli@googlemail.com> wrote:

> Subject: [PATCH] exec: delay address limit change until point of no return
> 
> Unconditionally changing the address limit to USER_DS and not restoring
> it to its old value in the error path is wrong because it prevents us
> using kernel memory on repeated calls to this function. This, in fact,
> breaks the fallback of hard coded paths to the init program from being
> ever successful if the first candidate fails to load.
> 
> With this patch applied switching to USER_DS is delayed until the point
> of no return is reached which makes it possible to have a multi-arch
> rootfs with one arch specific init binary for each of the (hard coded)
> probed paths.
> 
> Since the address limit is already set to USER_DS when start_thread()
> will be invoked, this redundancy can be safely removed.

A couple of things here, please.

The description doesn't describe the user-visible symptoms of the bug. 
This makes it hard for the -stable maintainers to work out whether they
should accept the patch and it makes it hard for random distro
maintainers to determine whether your patch might fix a user bug report
which they're working on.

Secondly, I understand that we have identified changes which other arch
maintainers should make and test.  Please describe those changes to
make it easy for them and please also describe a way in which they can
test that change.

Both these things could be addressed using a description of some
testcase.

