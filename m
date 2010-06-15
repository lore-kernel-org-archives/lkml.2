Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0FODrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 23:47:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40884
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247Ab0FODrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 23:47:48 -0400
Date: Mon, 14 Jun 2010 20:47:59 -0700 (PDT)
Message-Id: <20100614.204759.226765762.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 00/13] jump label v9
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jason, I'm really at wits end about this patch set.  To say
that trying to test our your patches is frustrating for me
so far would be an understatement.

Nothing you ever post builds for me, not one patch set has
built properly.

I can also tell that you're just blindly making changes to the
sparc bits and not trying to build test them at all:

1) Even though you created the jump_label_t, and made it properly
   a u32 on sparc, you left the assembler using ".xword" to
   record the entries.

2) The sparc "struct jump_label" still calls it's third member "name",
   it needs to be "key" or else the build breaks.

3) Eventhough the sparc JUMP_LABEL macro was fixed to have two args,
   the first arg was left as "tag" instead of being renamed to "key"
   and that name change propaged into the asm in the macro expansion.

I took care of that locally to try and test this, but then I hit the
current major problem which is that you're using things like
text_poke_early() unconditionally, but that is an X86-only facility
implemented by x86's alternative mechanism.

Also, kernel/jump_label.c only gets the ERR_PTR() definitions
indirectly on the x86 platform, it needs to include linux/err.h
directly to make sure those things are available on every platform.

You gave me the impression a few iterations ago that you were doing
build testing on sparc64 using cross-compilers, or that you would
start to do so.  You're obviously not, could you please start doing so
and let me know when you've at least build tested your jump-label
patch series on sparc64 and at least one architecture that lacks
jump-label support?

Thanks.
