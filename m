Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1GEQFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:05:42 -0400
Received: from mail.southpole.se ([193.12.106.18]:50920 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1GEQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:05:11 -0400
Subject: Re: [PATCH v2 06/19] OpenRISC: PTrace
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <201107051742.29359.arnd@arndb.de>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
	 <1309641352-18714-7-git-send-email-jonas@southpole.se>
	 <201107051742.29359.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 18:05:07 +0200
Message-ID: <1309881907.3393.15.camel@jerome>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-07-05 at 17:42 +0200, Arnd Bergmann wrote:
> On Saturday 02 July 2011, Jonas Bonn wrote:
> > Signed-off-by: Jonas Bonn <jonas@southpole.se>
> > ---
> >  arch/openrisc/include/asm/ptrace.h |  124 ++++++++
> >  arch/openrisc/kernel/ptrace.c      |  574 ++++++++++++++++++++++++++++++++++++
> >  arch/openrisc/kernel/ptrace.h      |   37 +++
> >  3 files changed, 735 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/openrisc/include/asm/ptrace.h
> >  create mode 100644 arch/openrisc/kernel/ptrace.c
> >  create mode 100644 arch/openrisc/kernel/ptrace.h
> 
> This patch still contains a bunch of commented out code that wants to be
> cleaned up. I think you have done that in most other patches that needed
> the same cleanup.
> 
> 	Arnd

I've been looking a bit at the ptrace stuff the last couple of days.
One question that occurred to me was:  is it mandatory to export the
"struct pt_regs" info in ptrace.h to userspace?

I'm not sure I like the layout of our struct pt_regs.  It would be
better to lay out the registers in a way that mirrors the order that
they are saved during exception/syscall entry in order to make better
use of the cache.

Since the registers can be exported via a regset to userspace anyway
(which doesn't necessarily need to look like pt_regs), I don't see that
userspace really needs how we lay out the registers on the stack.  By
not exporting pt_regs, I am free to change the layout... if it's
exported, it becomes ABI.

Comments?

/Jonas

