Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0JCFuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 01:50:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab0JCFuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 01:50:19 -0400
Date: Sun, 3 Oct 2010 07:50:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Drake <dsd@laptop.org>
Cc: jbaron@redhat.com, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: Dynamic nop selection breaks boot on Geode LX
Message-ID: <20101003055013.GB25397@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Drake <dsd@laptop.org>, jbaron@redhat.com,
	Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
	linux-kernel@vger.kernel.org, rostedt@goodmis.org
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Drake <dsd@laptop.org>
Date: Sat, Oct 02, 2010 at 08:16:19PM +0100

> Hi,
>
> linux-next fails to boot on OLPC's XO-1 laptop based on Geode LX
> processor.
>
> This is because of
>
> commit f49aa448561fe9215f43405cac6f31eb86317792 Author: Jason Baron
> <jbaron@redhat.com> Date: Fri Sep 17 11:08:51 2010 -0400
>
>     jump label: Make dynamic no-op selection available outside of
> ftrace
>
> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=co
> mmitdiff;h=f49aa44
>
> The Geode hangs inside the asm() statement inside
> arch_init_ideal_nop5.
>
> Any thoughts?

maybe because the Geode doesn't have both the
P6_NOP5 and the NOP with 4 0x66 prefixes:
http://kerneltrap.org/mailarchive/linux-kernel/2010/8/27/4612336

and for some reason the trap can't find the fixup address. You say
"hangs" so you don't even get an "invalid opcode" OOPS?

Maybe on a Geode jmp label should use the 2-byte jmp + 3 1-byte nops
unconditionally after adding a synthetic CPUID flag in init_amd_k6(), in
the Geode part.

-- 
Regards/Gruss,
    Boris.
