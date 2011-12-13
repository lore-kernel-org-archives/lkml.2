Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1LMPKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:10:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1LMPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:10:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Morell <rmorell@nvidia.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Tue, 13 Dec 2011 15:10:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sumit Semwal <sumit.semwal@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jesse.barker@linaro.org" <jesse.barker@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <4EE33EC2.6050508@redhat.com> <20111212224408.GD4355@morell.nvidia.com>
In-Reply-To: <20111212224408.GD4355@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112131510.02785.arnd@arndb.de>
X-Provags-ID: V02:K0:KAnt+06/LdSLPqxJ/HGr27yMoV3PoRaP0iNUr8dEWrx
 qHNdkUoxrYOskTfxauUL/EriUMzGbduo46Ca/M3rAIzR5OwxYC
 Pbtr2uKYU3OQzxHhrRUXPNmcFhtJDXxsUzPzcCVukOkh3LrguU
 XfvB28/nb+0A6sSd60FkA5dlAWACoCjHFfYLJ/lp90vbPr5zzT
 xsPnakVUKPww+2OIO7hrsDi42ATgoivw4IliOYhYKoRXpagj8V
 rdnXvPq4VVDD52Hfp2qc2NN3oVr7u85+Xqg5z7AXrKVPjE9q2B
 GnTb4gXfICZv1thV/AITdSPzgwx+c8ahF8yZ9JbdqUuNbPOzEz
 eOPEubbEnsvWyfvyyzvw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 December 2011, Robert Morell wrote:
> > 
> > Doing a buffer sharing with something that is not GPL is not fun, as, if any
> > issue rises there, it would be impossible to discover if the problem is either
> > at the closed-source driver or at the open source one. At the time I was using
> > the Nvidia proprietary driver, it was very common to have unexplained issues
> > caused likely by bad code there at the buffer management code, causing X
> > applications and extensions (like xv) to break.
> >
> > We should really make this EXPORT_SYMBOL_GPL(), in order to be able to latter
> > debug future share buffer issues, when needed.
> 
> Sorry, I don't buy this argument.  Making these exports GPL-only is not
> likely to cause anybody to open-source their driver, but will rather
> just cause them to use yet more closed-source code that is even less
> debuggable than this would be, to those without access to the source.

But at least the broken module then won't be interacting with other modules
because it cannot share any buffers.

	Arnd
