Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1C3MRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:17:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab1C3MRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:17:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] unicore32 fix: remove arch-specific futex support
Date: Wed, 30 Mar 2011 14:17:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn>
In-Reply-To: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301417.20027.arnd@arndb.de>
X-Provags-ID: V02:K0:aTWRYNkZHUYOw1MfDOYvHgMPuZodHt6hItaEaiaMoQS
 Dvswv4ZNVkl+aj9CqeGvcQkNm3ssQkYCXqS2syna0VU0DIZmoc
 4GMXaFUZxkRdhIVB3j4woFU13bzkDxILHYsRGjKriiP6RpHa0d
 /q2rMU1M0XOFTLBfjt4QRdvKOibtUwyrcStWjOtD27IjLmPPIG
 dDNf4NqTmGUDfthiJmkIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Guan Xuetao wrote:
> The futex functions in unicore32 are not used and verified,
> so just replaced by asm-generic version.
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Note that the a working futex implementation would be really useful
to get efficient multithreaded applications. On uniprocessor
machines, this can easily be done by disabling interrupts, like
you also do for spinlock and atomic.

I believe we could actually copy the arch/sh/include/asm/futex-irq.h
implementation to include/asm-generic and use that whenever CONFIG_SMP
is disabled. That would also help a lot of other architectures.

	Arnd
