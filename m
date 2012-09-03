Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2ICMkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:40:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2ICMj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:39:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 17/31] arm64: System calls handling
Date: Mon, 3 Sep 2012 12:39:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <20120822171309.GC2582@arm.com> <20120903114831.GA3313@mbp>
In-Reply-To: <20120903114831.GA3313@mbp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209031239.51515.arnd@arndb.de>
X-Provags-ID: V02:K0:FL01cub+wPcQZ31scsDHyhx4IxCtLPSp2cehwkXCtw9
 8emXvE2Uce583vdVHg0DwEElThgY9NkN4HP0C9WiCTifvRRiut
 0mZhnJD6cim4SWleCE2SyUP6qptDibbgwHg/f2+xIJqjuGE+bI
 vtfrJWiaQ+rT0otyf27sKYd5gFJ9dkPXgjfOvnrfa6E9E87KA/
 2GOWAhDzYFKU2AIYu5eL5wNbHQ8EynFdBLyrHDnnuNb2XWhrLw
 Rzf3Js4+6/u76jmsIzGLNvCMJE+u02jWpMOSA/FhQ2Bu6a0VHr
 mfYYtdbKmlPVN0+f22Sua4BrOT0WzinFsnBbgdDFjrTU1nowXG
 gHzzBPZoAIF5z2nKSPP0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2012, Catalin Marinas wrote:
> I forgot about this at the KS and we haven't got to a clear conclusion.
> 
> Do we (1) stick with the sys_mmap() for 64-bit systems and avoid offset
> conversion in both glibc and kernel or (2) use sys_mmap2() with a 12
> shift in glibc and (PAGE_SHIFT - 12) in the kernel wrapper?
> 
> I personally prefer (1) as it doesn't require a kernel wrapper and we
> avoid the double shifting. 

Yes, I think it's ok this way.

> A reason for (2) would be if we ever need file offsets greater than 16EB.

Let's not worry about this for now, all the other architectures will
have the same problem when we get there.

	Arnd
