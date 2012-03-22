Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030454Ab2CVAmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:42:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45230 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2CVAmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:42:01 -0400
Date: Thu, 22 Mar 2012 08:41:35 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: export 'pcibios_enabled'
Message-ID: <20120322004135.GA4253@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
	x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
 <4F5FAE63.3090908@xenotime.net>
 <4F5FE9AD.7000204@zytor.com>
 <20120314092955.2250a782@pyramind.ukuu.org.uk>
 <4F607A18.8080004@gmx.de>
 <20120314112137.68fa4f70@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314112137.68fa4f70@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:21:37AM +0000, Alan Cox wrote:
> You can use set_memory_x() to mark memory executable (and _nx to set it back).
> 
NO I can't, if I set_memory_x and don't set pcibios_enabled = 1, then
static_protections will still failed because pcibios_enabled == 0, 
and I don't want to use set_memory_x, because I don't want to give the user 
of uvesafb that feeling "I will lost BIOS NX protection if I choice uvesafb."

> If you really need to know if NX is being used then the check
> 
> 	if (__supported_pte_mask & PTE_NX)
> 
> will do the trick and the variable is exported.
I don't understand what do you mean, do you means CONFIG_X86_PAE for 32? Or CONFIG_X86_64?
when NX is being used, the pci bios is NX or not also depend on
ACPI.ACPI on or off all will influnce the code path in pci_arch_init,
decide the set_bios_x have chance to execute or not.See
https://lkml.org/lkml/2011/11/16/84

By the way _PAGE_NX instead of PTE_NX, right?

> I'd suggest however you wrap that in a cpu_has_nx() type macro somewhere
> in the arch headers.
> 
The same above.

> If you go poking around pcibios values you are going to get burned if
> someone is ever bored enough to make NX and PCIBIOS work together
> differently.
> 
Indeed according to 5bd5a452662bc37c54fb6828db1a3faf87e6511c, who bring me 
the trouble, check the pcibios_enabled is the only simple and good way to 
resolve the Oops I meet.

If you really don't want it, and if I am not all wrong about your "helper method",
you means you want export the below:
int check_pcibios_enabled()?
See https://lkml.org/lkml/2012/2/26/124

Thanks.

