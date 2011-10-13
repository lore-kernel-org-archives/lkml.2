Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1JMOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:25:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63098 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab1JMOZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOZdJXVLhe3aNM669sRFmDpHGCVRrP_93xdDwsY9R2VzHUZ-eQ@mail.gmail.com>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
	<20111012153229.GB21852@local>
	<AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
	<CAMuHMdU1rHDvZEknNqKLHyBmJ26kH7SJtxsOZmOysrSzg6bz4g@mail.gmail.com>
	<CAOZdJXVLhe3aNM669sRFmDpHGCVRrP_93xdDwsY9R2VzHUZ-eQ@mail.gmail.com>
Date: Thu, 13 Oct 2011 16:25:56 +0200
X-Google-Sender-Auth: Gh2A6-nofK0yRs2xhEf9cWOunNM
Message-ID: <CAMuHMdVYsMj99jTJRj_NJ_dCg+b-39ExnDD1Mhqnv3R6tWf1iQ@mail.gmail.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Kai-B18973 <B18973@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 16:10, Tabi Timur-B04825 <B04825@freescale.com> wrote:
> On Wed, Oct 12, 2011 at 11:15 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>>> Do we believe phys_addr_t is always greater than or equal to size need for logical & virtual addresses?
>>
>> Yes:
>>
>> #ifdef CONFIG_PHYS_ADDR_T_64BIT
>> typedef u64 phys_addr_t;
>> #else
>> typedef u32 phys_addr_t;
>> #endif
>
> This isn't really an answer to the question.  This just says that
> phys_addr_t can be 64-bit.  I don't see anywhere in the kernel that we
> *enforce* or *require* that sizeof(phys_addr_t) >= sizeof(void *).

You deleted this part:

config PHYS_ADDR_T_64BIT
       def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT

which enforces that PHYS_ADDR_T_64BIT is enabled if 64BIT is set.

It still doesn't protect against 64-bit architectures not setting 64BIT,
but they have worse problems ;-)

On 32-bit platforms, void * is 32-bit, and phys_addr_t is either
32-bit or 64-bit.
On 64-bit platforms (which are required to set 64BIT), void * is 64-bit,
just like phys_addr_t.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
