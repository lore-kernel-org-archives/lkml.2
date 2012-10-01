Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2JATAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:00:15 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46014 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2JATAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <20121001160043.GF12460@arm.com>
References: <20121001160043.GF12460@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Oct 2012 11:59:52 -0700
X-Google-Sender-Auth: 2q9ry3iOWG0reA7OCYkXjrj2Hac
Message-ID: <CA+55aFxefxzYB1iLFfWJeen6XK+5MZEMDjMLJQPS9Satr_5CxA@mail.gmail.com>
Subject: Re: [GIT PULL] arm64: Linux kernel port
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 9:00 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Please pull the tag below containing the arm64 Linux port. The code
> lives primarily under arch/arm64/ with a few bits of generic code
> outside this. Thanks.

Ok, pulled.

However, looking at the non-arm64 changes, I note:

 - the UID16 config option *has* to be fixed.

   This is not really about arm64, the ugliness comes from every crazy
architecture. But we really need to fix this to have something like a
"HAVE_UID16" config option, and have the architectures that support
this select that option, so that the UID16 config option can just have
a "depends on HAVE_UID16".

   Please? Anybody?

 - same goes for DEBUG_KMEMLEAK and DEBUG_BUGVERBOSE.

 - very similar issues for the crazy mess of "#if defined()" in
kernel/sysctl.c. Can we please just add a SYSCTL_EXCEPTION_TRACE
config option, and have the architectures that want this just select
it?

Hmm? Having new architecture have to mess with these kinds of things,
and making the thing continually uglier is just nasty.

I'm sure there are other cases like this elsewhere, but these were the
ones that the arm64 pull showed.

               Linus
