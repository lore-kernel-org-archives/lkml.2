Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1JLQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:15:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38364 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1JLQPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
	<20111012153229.GB21852@local>
	<AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
Date: Wed, 12 Oct 2011 18:15:49 +0200
X-Google-Sender-Auth: xEoSWbGCbWnmQW0a8LQowlfsYYQ
Message-ID: <CAMuHMdU1rHDvZEknNqKLHyBmJ26kH7SJtxsOZmOysrSzg6bz4g@mail.gmail.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, gregkh@suse.de, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Kai Jiang <Kai.Jiang@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 18:07, Kumar Gala <galak@kernel.crashing.org> wrote:
> On Oct 12, 2011, at 10:32 AM, Hans J. Koch wrote:
>> On Wed, Oct 12, 2011 at 09:35:45AM -0500, Kumar Gala wrote:
>>> From: Kai Jiang <Kai.Jiang@freescale.com>
>>>
>>> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
>>> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
>>> embedded PPC, ARM, and X86 have support for systems with larger physical
>>> address than logical.
>>>
>>> Since 'addr' may contain a physical, logical, or virtual address the
>>> easiest solution is to just change the type to 'unsigned long long'
>>> regardless of which type is utilized.
>>
>> No. There's phys_addr_t for that purpose, defined in include/linux/types.h.
>> Please use that.
>
> Do we believe phys_addr_t is always greater than or equal to size need for logical & virtual addresses?

Yes:

#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif

config PHYS_ADDR_T_64BIT
        def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
