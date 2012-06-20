Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2FTMva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:51:30 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:60822 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab2FTMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:51:29 -0400
Message-ID: <4FE1C6FF.9070302@st.com>
Date: Wed, 20 Jun 2012 14:50:07 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: Build regressions/improvements in v3.5-rc3
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org> <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com> <20120620035951.GC5623@linux-sh.org>
In-Reply-To: <20120620035951.GC5623@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul

On 6/20/2012 5:59 AM, Paul Mundt wrote:
> On Sun, Jun 17, 2012 at 09:56:59PM +0200, Geert Uytterhoeven wrote:
>> On Sun, Jun 17, 2012 at 9:46 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> JFYI, when comparing v3.5-rc3 to v3.5-rc2[3], the summaries are:
>>> ??- build errors: +235/-10
>>
>> Truckloads of powerpc "Unrecognized opcode" breakage, and
>>
> That was my fault, should be fixed up by 2603efa31a.
> 
>>   + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit
>> declaration of function 'pci_iomap'
>> [-Werror=implicit-function-declaration]:  => 90:3
>>   + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit
>> declaration of function 'pci_iounmap'
>> [-Werror=implicit-function-declaration]:  => 142:2
>>
> Not sure about this one, it should find everything alright via:
> 
> 	linux/io.h -> asm/io.h -> asm-generic/iomap.h -> asm-generic/pci_iomap.h
> 
> in the case that PCI is enabled. None of allyesconfig/modconfig enable
> PCI for me though, so I'm unsure of how you got in to this configuration
> to begin with?

Trying to reproduce the problem, I've also re-built the mainstream
kernel 3.5-rc3 for se7724_defconfig platform plus the stmmac (pltf and
pci) but all compiles fine.

I've also verified that there is the 33d5e332b9c5 commit that is the
latest one discussed/tested/committed in the network mailing list.

Can you tell me how to reproduce the problem? How can I help?

Pls let me know,
Peppe
