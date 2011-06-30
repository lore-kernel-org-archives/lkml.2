Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1F3UDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:03:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab1F3UDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <1309461732-2875-1-git-send-email-jonas@southpole.se>
References: <201106281245.19457.arnd@arndb.de> <1309461732-2875-1-git-send-email-jonas@southpole.se>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Jun 2011 13:02:10 -0700
Message-ID: <BANLkTim3k+eRZHnpWLVHe0Q9SoU9w4zm=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] modules: add default loader hook implementations
To: Jonas Bonn <jonas@southpole.se>
Cc: rusty@rustcorp.com.au, arnd@ardnb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:22 PM, Jonas Bonn <jonas@southpole.se> wrote:
>
> The module loader code allows architectures to hook into the code by
> providing a small number of entry points that each arch must implement.
> This patch provides __weakly linked generic implementations of these
> entry points for architectures that don't need to do anything special.

Hmm. I know we used to have problems with gcc versions (or maybe
binutils) that had bugs wrt "weak" functions being declared in the
same compilation unit they were used. They would either inline the
weak function, or bind it early, and never let the linker see the
weak/strong functions and do the right thing.

I just don't remember if we disallowed those gcc/binutils versions and
check for it, or whether we decided that __weak function smust be
defined in a compilation unit separate from the user.

Because you now added all the weak functions to the same file
(module.c) that actually uses them.

Commit f9d14250071e ("Disallow gcc versions 4.1.{0,1}") implies we
disallowed the broken versions entirely, but I'm not entirely sure
those were the only cases.

Anybody remember?

                     Linus
