Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2CZUpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:45:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2CZUpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:45:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] compat: use sys_sendfile64() implementation for sendfile syscall
Date: Mon, 26 Mar 2012 20:45:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201203262036.q2QKaZ7U009929@farm-0012.internal.tilera.com>
In-Reply-To: <201203262036.q2QKaZ7U009929@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203262045.16243.arnd@arndb.de>
X-Provags-ID: V02:K0:IrYyUDVAo3bvksr49t7tncTR0k/bdR145y8Z7gGKnt9
 aZrpTrAFk1dbI/71BVUoxsJtiVfzGEIO2I+wweeKDzYNAGR5wF
 crC5zq6RWb6P7NxCOJZ11CsXTPAWp6RSXQdHsnWqlZl8Bn6ogL
 YeoIFQqRtcjm2wxkD6H68uv700oKeo4ZISSSwLaLdb/G2GtKrp
 KQd6398AHC4DIVNdAj6Hy3WVz9ZVZsYc/TMWeaVUsS5iDcguUw
 FcOoWoiQe2SfmjaqfaeqpN/IXmjLIE6YP3cKnq4NNC/4AWax04
 YaYqi0rgf9TQjVqo0nrc0E0X9mt2ZtlQsMs5ASLhYFKrXsI/KW
 unHoyHdChL1uDL9hrSG4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2012, Chris Metcalf wrote:
> <asm-generic/unistd.h> was set up to use sys_sendfile() for the 32-bit
> compat API instead of sys_sendfile64(), but in fact the right thing to
> do is to use sys_sendfile64() in all cases.  The 32-bit sendfile64() API
> in glibc uses the sendfile64 syscall, so it has to be capable of doing
> full 64-bit operations.  But the sys_sendfile() kernel implementation
> has a MAX_NON_LFS test in it which explicitly limits the offset to 2^32.
> So, we need to use the sys_sendfile64() implementation in the kernel
> for this case.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
