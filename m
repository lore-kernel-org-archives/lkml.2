Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab2CNTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:08:07 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:7416 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2CNTIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:08:00 -0400
Message-ID: <4F60EC8C.1040400@tilera.com>
Date: Wed, 14 Mar 2012 15:07:56 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <torvalds@linux-foundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: Re: [PATCH] tile: remove a non-existing header
References: <1331561930-14964-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331561930-14964-1-git-send-email-mchehab@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 10:18 AM, Mauro Carvalho Chehab wrote:
> Btw, the ./arch/tile/configs/tilepro_defconfig doesn't compile even
> with this fix. It fails at arch/tile/include/asm/atomic_64.h because
> atomic64_t is never defined, but it is used there and on other places.

I suspect you may be trying to use tilepro_defconfig with ARCH=tilegx. 
It's only valid for ARCH=tilepro, just like tilegx_defconfig is only valid
for ARCH=tilegx.  There's some #ifdefs that are supposed to catch this (in
asm-offsets.c) but it's coming too late.  I'll move it so it's before all
the #includes so at least it will be the first error that you see!

> Also, while the edac_tile driver seems to be for both Tile GX and Tilepro
> sub-archs, it is not included on tilegx_defconfig. It would make sense
> to add it there, in order to make easier for people to test/use the
> EDAC drivers.

Fixed now in Linus' tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

