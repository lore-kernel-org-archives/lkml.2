Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1LAPmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:42:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1LAPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:42:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Android-virt] [Embeddedxen-devel] [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
Date: Thu, 1 Dec 2011 15:42:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <1322735197.31810.191.camel@zakaz.uk.xensource.com> <20111201151043.GG27394@arm.com>
In-Reply-To: <20111201151043.GG27394@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011542.19377.arnd@arndb.de>
X-Provags-ID: V02:K0:Ycdbw+ncFty38WKX6qb8TPkidZ48FAgA7MIw/6DZTG2
 GXdjKYlLACwgkS7naCbeV5TR1TrfAH6eld5dEaUUieNUh0YP5P
 eSUG9qmH2w14JiS+/+Sbh+EJ+uVqREZs6sh0DBisSIU3FKNRyX
 k5uckZFQPPDDKC5qW2+Zd9BxH48CIdBD1cleue4Di3FkHLDm1S
 lkeg0EMqjzd79Zcpsi3QyuaAiNvB7HI7OyZye0Tkh+i+Y9fKCk
 +bSB5D7/i9gYXgrkKQUH4Hy9e4nmyykCpAUuRYAr0rtXgIMz+e
 b1g/cGwzy56gKDw5cNFCZvl702k8Mqax6eiaWLbWvCa3rAWxJp
 +cQbDW2VqhoxB2QxAxNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011, Catalin Marinas wrote:
> Given the way register banking is done on AArch64, issuing an HVC on a
> 32-bit guest OS doesn't require translation on a 64-bit hypervisor. We
> have a similar implementation at the SVC level (for 32-bit user apps on
> a 64-bit kernel), the only modification was where a 32-bit SVC takes a
> 64-bit parameter in two separate 32-bit registers, so packing needs to
> be done in a syscall wrapper.

How do you deal with signed integer arguments passed into SVC or HVC from
a caller? If I understand the architecture correctly, the upper
halves of the argument register end up zero-padded, while the callee
expects sign-extension.

	Arnd
