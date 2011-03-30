Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1C3Mpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:45:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1C3Mpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:45:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] unicore32 fix: remove arch-specific futex support
Date: Wed, 30 Mar 2011 14:40:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn> <201103301417.20027.arnd@arndb.de> <alpine.LFD.2.00.1103301421390.22418@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103301421390.22418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301440.03479.arnd@arndb.de>
X-Provags-ID: V02:K0:ZCKAxxh25mKPzmPsqMKx+Wgt6Iwrq4xaaVd5Y6M3xKN
 YOZptsJQ3hxP1c4qXiTVZxJ+z581tXCVd5Rqt2sxBeJ/d5NEhS
 MtxQpIhbzbvpKtqQ/0PmsNiycZL2b9pPOSTs/hT8X/ENHsahcx
 KG0W0R7P9+jp9IolyTM1XGh+BF16D6Z7ognhgyJ0PKyOjLmoX+
 ebiIJzsVjhtFEUJjrWITw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Thomas Gleixner wrote:
> The problem is that you need cmpxchg in user space as well.
> 
> ARM does this with some syscall magic for machines which do not have
> cmpxchg.

Ah, right. I wonder how sh does it.

I also remember that the original unicore32 ABI had support for a cmpxchg
system call, but that was removed with the move to the generic syscall
table.

It is of course possible to add it back using the __NR_arch_specific_syscall
entry point.

	Arnd
