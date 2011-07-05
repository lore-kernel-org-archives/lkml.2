Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1GEQmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab1GEQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH v2 06/19] OpenRISC: PTrace
Date: Tue, 5 Jul 2011 18:42:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1309641352-18714-1-git-send-email-jonas@southpole.se> <201107051742.29359.arnd@arndb.de> <1309881907.3393.15.camel@jerome>
In-Reply-To: <1309881907.3393.15.camel@jerome>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051842.11666.arnd@arndb.de>
X-Provags-ID: V02:K0:OU786fxOSSoWU9HAjk5VCoanoHHv591aqsuVNLmwkHa
 IJNa0dIO6LsjYvaK38cHfE9Y37DYP4X4WXprNmaMaPtdFSXaTQ
 RPduUxCB2SX81YkeVUf8+4R2V9nBP4Y+4uVdYwCxrKUKr/Gtvw
 LE8P6imDMoCntPTN74798dcWCqUlA35kqQgpjaSBlxBZtmbpPx
 CpjAK24svYf6Vvsq7+kNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Jonas Bonn wrote:
> I've been looking a bit at the ptrace stuff the last couple of days.
> One question that occurred to me was:  is it mandatory to export the
> "struct pt_regs" info in ptrace.h to userspace?

I don't know, it certainly has been the case traditionally, but as
far as I can tell, this was mainly used by ancient gdb ports,
while newer versions just hardcode the offsets for PTRACE_PEEKUSR.

> I'm not sure I like the layout of our struct pt_regs.  It would be
> better to lay out the registers in a way that mirrors the order that
> they are saved during exception/syscall entry in order to make better
> use of the cache.
> 
> Since the registers can be exported via a regset to userspace anyway
> (which doesn't necessarily need to look like pt_regs), I don't see that
> userspace really needs how we lay out the registers on the stack.  By
> not exporting pt_regs, I am free to change the layout... if it's
> exported, it becomes ABI.

Yes. I think you can just change your ptrace code to not export
pt_regs through PEEKUSR but only through elf_gregset_t, which
you can define independently.

	Arnd
