Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0FORM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:12:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34997
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757671Ab0FORMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:12:55 -0400
Date: Tue, 15 Jun 2010 10:13:06 -0700 (PDT)
Message-Id: <20100615.101306.260078767.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 00/13] jump label v9
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100615142811.GB2750@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	<20100614.204759.226765762.davem@davemloft.net>
	<20100615142811.GB2750@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Tue, 15 Jun 2010 10:28:11 -0400

> For example, the reason I have it in the code is b/c x86 determines
> the best no-op at run-time. Are other architectures going to have to
> require this kind of functionality. Or like sparc, are we going to
> be able to generally hard-code the nops on non-x86 at compile-time?

I think most architectures will use a constant nop sequence, in fact
x86 is the only one I can think of that needs variable nop sequences.

Why not abstract this behind some asm/jump_label.h macro just like
everything else?  "jump_label_text_poke_early()" or similar.
On sparc64 I would define this to:

#include <asm/system.h>

static inline void jump_label_text_poke_early(void *addr, const void *opcode, size_t len)
{
	u32 new_insn = *(u32 *)opcode;
	u32 *insn_p = (u32 *) addr;

	*insn_p = new_insn;
	flushi(insn_p);
}
