Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab2HVPby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:31:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab2HVPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:31:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 0/4] [RFC] ARM: multiplatform: rename all mach headers
Date: Wed, 22 Aug 2012 15:31:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
References: <201208221253.07278.arnd@arndb.de> <alpine.LFD.2.02.1208221106010.1754@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208221106010.1754@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221531.42845.arnd@arndb.de>
X-Provags-ID: V02:K0:Ra2czX2IkxkX1PMaKT547wKxxg4oBaIt7pFOtzhjUpA
 VcV991jpj5Bfag2wNbquJktOro9Vvg+cv2PDbmYXrY/IC2yZEi
 J29iv6lpf8Y7RqWX86A1bk8TNTBWpU+RNZ8daG4d3Ortw0ZCgo
 x+OZqXpK8315yhkO7KIB8rALbTGohXIauexvXVy03KOxTFmMbE
 Xe4MmvZY09VXaKhpzY5hiE4hFjOHT2m5bioPtbkbWjFAfvoTnb
 ohJBhDHiszb4nNvkH2krf/be9ikrGH8ELw+JfQ4IKn3W+45CU6
 4P6aktgFsE000KbrNPvgHnjJYwbtrFAbPpAJJfqNcZkPGm4N/G
 3dZCrT7d+VQEwlGyojYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Nicolas Pitre wrote:
> On Wed, 22 Aug 2012, Arnd Bergmann wrote:
> > There are two branches available in the arm-soc tree:
> > 
> > 1. This series,
> >    http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=shortlog;h=refs/heads/testing/mach-headers
> >    This just moves header files around and changes most of the
> >    files including them. There are a few remaining drivers
> >    and platform files that keep including a generic file name
> >    like <mach/uncompress.h>. It remains possible to do that,
> >    and I've run extensive tests to ensure I did not break
> >    anything with this. However, each of these instances means
> >    that there is something that stops working when you get to
> >    the real multiplatform kernel and we still need to deal
> >    with them one by one.
> 
> The content of <mach/uncompress.h> is fundamentally machine or SOC 
> specific.  We already know it is generally incompatible with a multi 
> platform kernel.  So the best way to deal with this at the moment is 
> probably to just provide a dummy uncompress.h with empty stubs whenever 
> CONFIG_ARCH_MULTIPLATFORM is selected.  The effect from this is that 
> there wouldn't be any "Uncompressing the kernel... Done" output anymore, 
> which should be an acceptable compromise until a better solution is 
> found.

Yes, that is what I do in the second series.

> One problem is that some (very few) machines define a method in that 
> file to keep a hardware watchdog alive.  This might not be the case for 
> all the intended targets to gather in a single kernel binary image 
> though.

Ok. I think we have a list of known issues somewhere, we should add this
one. I just can't remember where that list is located.

> Another issue is the fact that some platforms do very ugly 
> layer-violating hacks where the decompressor selects a serial port for 
> early output and then store that selection in some arbitrary memory 
> location for the main kernel to blindly use, making the decompressor 
> mandatory.  OMAP and Davinci are prime example of such "abuse" which 
> would need to be fixed.

Same thing here I guess.

Thanks for the input!

	Arnd
