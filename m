Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0DAWGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:06:43 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26783 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab0DAWGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:06:38 -0400
Date: Thu, 1 Apr 2010 15:03:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH -v2] ibft, x86: Change reserve_ibft_region() to 
 find_ibft_region()
Message-Id: <20100401150326.4b068c09.randy.dunlap@oracle.com>
In-Reply-To: <n2n86802c441004011500z441e91d8nc4453d6e85c82d5@mail.gmail.com>
References: <4BB3FFE4.4010909@kernel.org>
	<4BB510FB.80601@kernel.org>
	<20100401145448.31e56d0e.randy.dunlap@oracle.com>
	<n2n86802c441004011500z441e91d8nc4453d6e85c82d5@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB518A3.0120:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 15:00:05 -0700 Yinghai Lu wrote:

> On Thu, Apr 1, 2010 at 2:54 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Thu, 01 Apr 2010 14:32:43 -0700 Yinghai Lu wrote:
> >
> >>
> >>
> >> So arch code could decide the way to reserve the ibft.
> >>
> >> And We should reserve ibft as early as possible, instead of BOOTMEM stage,
> >> in case the table is in RAM range and is not reserved by BIOS.
> >>
> >> move that just sfter find_smp_config()
> >>
> >> Also when CONFIG_NO_BOOTMEM=y, We will not have reserve_bootmem() anymorea
> >>
> >> -v2: fix typo about ibft pointed by Konrad Rzeszutek Wilk <konrad@darnok.org>
> >
> >
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> >> Cc: Peter Jones <pjones@redhat.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> >> CC: Jan Beulich <jbeulich@novell.com>
> >>
> >> ---
> >>  arch/x86/kernel/setup.c            |   14 ++++++++++++--
> >>  drivers/firmware/iscsi_ibft_find.c |   11 ++++++++---
> >>  include/linux/iscsi_ibft.h         |    8 ++++++--
> >>  3 files changed, 26 insertions(+), 7 deletions(-)
> >>
> >> Index: linux-2.6/arch/x86/kernel/setup.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/kernel/setup.c
> >> +++ linux-2.6/arch/x86/kernel/setup.c
> >> @@ -608,6 +608,16 @@ static int __init setup_elfcorehdr(char
> >>  early_param("elfcorehdr", setup_elfcorehdr);
> >>  #endif
> >>
> >> +static __init void reserve_ibft_region(void)
> >> +{
> >> +     unsigned long addr, size = 0;
> >> +
> >> +     addr = find_ibft_region(&size);
> >> +
> >> +     if (size)
> >> +             reserve_early_overlap_ok(addr, addr + size, "ibft");
> >
> >        where is the correction?
> 
> -v1 has
> 
>  +     if (size)
>  +             reserve_early_overlap_ok(addr, addr + size, "ifbt");

Thanks.  My eyes are blurry.  ;)

---
~Randy
