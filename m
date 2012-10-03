Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2JCWPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:15:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2JCWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:15:07 -0400
Date: Wed, 3 Oct 2012 15:15:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 1/4] Clean up the long arch list for the UID16 config
 option
Message-Id: <20121003151505.8d59b646.akpm@linux-foundation.org>
In-Reply-To: <1349282666-32100-2-git-send-email-catalin.marinas@arm.com>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
	<1349282666-32100-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Oct 2012 17:44:23 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> This patch introduces HAVE_UID16 config option and selects it in
> corresponding architecture Kconfig files. UID16 now only depends on
> HAVE_UID16.

patching file arch/arm/Kconfig
Hunk #1 FAILED at 49.
1 out of 1 hunk FAILED -- saving rejects to file arch/arm/Kconfig.rej
patching file arch/arm64/Kconfig
patching file arch/blackfin/Kconfig
Hunk #1 FAILED at 42.
1 out of 1 hunk FAILED -- saving rejects to file arch/blackfin/Kconfig.rej
patching file arch/cris/Kconfig
Hunk #1 FAILED at 47.
1 out of 1 hunk FAILED -- saving rejects to file arch/cris/Kconfig.rej
patching file arch/frv/Kconfig
Hunk #1 FAILED at 10.
1 out of 1 hunk FAILED -- saving rejects to file arch/frv/Kconfig.rej
patching file arch/h8300/Kconfig
Hunk #1 FAILED at 6.
1 out of 1 hunk FAILED -- saving rejects to file arch/h8300/Kconfig.rej
patching file arch/m68k/Kconfig
Hunk #1 FAILED at 13.
1 out of 1 hunk FAILED -- saving rejects to file arch/m68k/Kconfig.rej
patching file arch/s390/Kconfig
Hunk #1 FAILED at 132.
1 out of 1 hunk FAILED -- saving rejects to file arch/s390/Kconfig.rej
patching file arch/sh/Kconfig
Hunk #1 FAILED at 35.
1 out of 1 hunk FAILED -- saving rejects to file arch/sh/Kconfig.rej


This is a pet peeve of mine.  Any time there's a long list of items
(header file inclusions, kconfig entries, array initalisers, etc) and
someone wants to add a new item, they *always* go and stick it at the
end of the list.

Which is exactly where everyone else applies their modifications.  The
whole thing is carefully set up to maximise the number of conflicts.

Guys, don't do this.  Either put the new item into a randomly-chosen
position or, probably better, alphanumerically sort the list.


For this reason it looks like approximately 0% of the patchset will
apply, sorry.

