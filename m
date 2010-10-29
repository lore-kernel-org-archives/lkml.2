Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869Ab0J2Uhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:37:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46238
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391Ab0J2Uhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:37:35 -0400
Date: Fri, 29 Oct 2010 13:37:59 -0700 (PDT)
Message-Id: <20101029.133759.48489968.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        fweisbec@gmail.com, jbaron@redhat.com, ddaney@caviumnetworks.com
Subject: Re: [PATCH 4/8] jump label: Make arch_jump_label_text_poke_early()
 optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101028135647.822609872@goodmis.org>
References: <20101028135548.055490014@goodmis.org>
	<20101028135647.822609872@goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 28 Oct 2010 09:55:52 -0400

> From: David Daney <ddaney@caviumnetworks.com>
> 
> For the forthcoming MIPS jump label support,
> arch_jump_label_text_poke_early() is unneeded as the MIPS NOP
> instruction is already optimal.
> 
> Supply a default implementation that does nothing.  Flag x86 and SPARC
> as having arch_jump_label_text_poke_early().
> 
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> LKML-Reference: <1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

On the SPARC side, it's not that the nop isn't optimal, on sparc it's
always 0x01000000.  The issue is that when written an I-cache flush is
necessary using a 'flushi' instruction.

Does MIPS not need a flush when poking instructions?  I find this hard
to believe, although it's been some time since I last touched that
architecture :-)
