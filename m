Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2FFPUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:20:38 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:23565 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178Ab2FFPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:20:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAMxzz0/CTtAn/2dsb2JhbABFtDWBB4IYAQEFJxM/EAsYLhQYMROID7dZixiFOWADlRwBiSOGV4Ji
Date: Wed, 6 Jun 2012 17:20:30 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
	and strnlen_user()
Message-ID: <20120606152030.GA9809@frolo.macqel>
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org> <20120530102226.GA28628@frolo.macqel> <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com> <20120530140444.GA10543@frolo.macqel> <CAMuHMdW0XqO9iOiuOXrRao_A41L-0iZXXyZugCmiizG=7-VkHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW0XqO9iOiuOXrRao_A41L-0iZXXyZugCmiizG=7-VkHg@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed, Jun 06, 2012 at 03:44:03PM +0200, Geert Uytterhoeven wrote:
> On Wed, May 30, 2012 at 4:04 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> >> > Sorry, I did not follow what happened to unaligned accesses, but
> >> > CPU32 family (at least 68340) crashes on unaligned accesses.
> >>
> >> We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?
> >
> > I have a local port here (but based on an ancient linux kernel, 2.6.2 IIRC)
> 
> Just to be sure: basically include/asm-m68knommu/unaligned.h has always
> been wrong (also in 2.6.2), so you had to fix this locally?

I have just verified, and you are right :

	include/asm-m68knommu/unaligned.h was wrong in 2.6.2

But I did not have to fix it locally.

I remember the ppp driver kernel doing by error unaligned accesses
(of course without using unaligned macros) and crashing my kernel.
I fixed the error in the ppp driver and the fix went into the
mainline kernel.

I am not aware that unaligned macros were used in the parts of the
kernel I used on this board.  Just to be sure I made a quick list :

$ find -name \*.o | sed -e 's/\.o$/.c/' | xargs grep t_unaligned 2> /dev/null
./fs/partitions/msdos.c:#define SYS_IND(p) (get_unaligned(&p->sys_ind))
./fs/partitions/msdos.c:                   get_unaligned(&p->nr_sects); \
./fs/partitions/msdos.c:                   get_unaligned(&p->start_sect);      \
./drivers/net/slhc.c:   put_unaligned(ip_fast_csum(icp, ip->ihl),

I am 100% sure I did not use msdos partitions on that board.  I don't
know why msdos.c was compiled in.  For the slhc case, I surmise that it
was not used because its usage depends on some option we did not use.

Best regards

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
