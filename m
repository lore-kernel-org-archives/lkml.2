Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1IJGmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 02:42:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36225 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab1IJGm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 02:42:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110909211808.GA3150@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
	<20110909010916.525482401@codeaurora.org>
	<CACM3HyGvJQABO3Hi6e+yH+Xoi+S+fctGrH3w4Jm7=zqtnPTXTQ@mail.gmail.com>
	<20110909211808.GA3150@codeaurora.org>
Date: Sat, 10 Sep 2011 08:42:26 +0200
Message-ID: <CACM3HyH8P=u9pR0sa2besxsgDN5TUKg_7utLJTwL+hu8Wv48ow@mail.gmail.com>
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
From: Jonas Bonn <jonas.bonn@gmail.com>
To: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2011 23:18, Linas Vepstas (Code Aurora)
<linas@codeaurora.org> wrote:
> On Fri, Sep 09, 2011 at 10:15:20PM +0200, Jonas Bonn wrote:
>>
>> That said, I don't think gdbserver has been updated to use
>> GETREGSET/SETREGSET.  This is a bit like the uClibc/glibc issue,
>
> Some dumb questions then: I notice that a few arches declare
> struct user_regs_struct in glibc, most of the others in the
> kernel.  If I were to make pt_regs completely kernel-private,
> then I really do need to have struct user_regs_struct declared
> the kernel headers, right?

Yes, on OpenRISC we declare it in ptrace.h (see
arch/openrisc/include/asm/ptrace.h).

>
> Putting a printk into case PTRACE_POKEUSR seemed to show that
> gdb was using this (and was somehow mis-numbering the registers
> ... sigh.) Are you saying that the default should handle this?

I'm really not an expert on GDB, but I believe it can use either the
PEEK/POKE functions to access regs, or it can use GET/SETREGS; it's an
architecture-dependent configuration.  I think the second variant can
be easily modified to become GET/SETREGSET instead, and the PEEK/POKE
variant wouldn't be needed at all.

/Jonas
