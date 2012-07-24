Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2GXOjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:39:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab2GXOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:39:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cyril Chemparathy <cyril@ti.com>
Subject: Re: [RFC 23/23] ARM: keystone: add switch over to high physical address range
Date: Tue, 24 Jul 2012 14:39:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nico@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-24-git-send-email-cyril@ti.com>
In-Reply-To: <1343092165-9470-24-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241439.25314.arnd@arndb.de>
X-Provags-ID: V02:K0:A/SSDq9gj+VTEFSFgJRGOwuGsqunbBai2SiImYdDXfu
 gML4KmazSty01ncuWWcZCpCsh2NHPdhHCXLt5H3Yl7/78XTfuK
 ZAGPJTwn62H26EMoVaF34nG/12ovbI0Bsy3rtNiRFAAyarz9Tt
 tjv7vdGO1g0R31VorepaxPzUuWsumWDcOYrm5/A1zLBKMmJkea
 VePr+JD0y/saajlbfrJFRjsSiVamUqJdh6I9nVRHYxV/q88tsN
 oNomOX1O1cSVikPxkHARA0zSToLgOLFGDUCYY13CrjShWhB9Or
 SHFAoPqze3+MH1b3sb8WcFny/VLLOwABMOMRd66joz+su0u7sx
 pw20mddsJmZau18ers2Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012, Cyril Chemparathy wrote:
> Keystone platforms have their physical memory mapped at an address outside the
> 32-bit physical range.  A Keystone machine with 16G of RAM would find its
> memory at 0x0800000000 - 0x0bffffffff.
> 
> For boot purposes, the interconnect supports a limited alias of some of this
> memory within the 32-bit addressable space (0x80000000 - 0xffffffff).  This
> aliasing is implemented in hardware, and is not intended to be used much
> beyond boot.  For instance, DMA coherence does not work when running out of
> this aliased address space.
> 
> Therefore, we've taken the approach of booting out of the low physical address
> range, and subsequently we switch over to the high range once we're safely
> inside machine specific territory.  This patch implements this switch over
> mechanism, which involves rewiring the TTBRs and page tables to point to the
> new physical address space.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

I think this needs some more explanations. Why is not not possible
to use this the larger area from the start when we first enable
paging?
Also, the code does not really look platform specific, so I could
imagine that if you need it, other similar platforms will need the
same thing, and it should be put into common code and enabled
all the time when using LPAE.

	Arnd
