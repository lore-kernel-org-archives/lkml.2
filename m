Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2AROJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:09:21 -0500
Received: from ihemail1.lucent.com ([135.245.0.33]:41812 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab2AROJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:09:20 -0500
X-Greylist: delayed 810 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 09:09:19 EST
Date: Wed, 18 Jan 2012 07:55:34 -0600 (CST)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Dave Airlie <airlied@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Robert Morell <rmorell@nvidia.com>, sumit.semwal@linaro.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
In-Reply-To: <CAPM=9txEgGgbim5Gtz5=Cr5Mf3NrQCx0D=0dQu25gtPTzjSM7Q@mail.gmail.com>
Message-ID: <Pine.GSO.4.62.1201180733450.26200@umail>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
 <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
 <201201181214.12055.arnd@arndb.de> <CAPM=9txEgGgbim5Gtz5=Cr5Mf3NrQCx0D=0dQu25gtPTzjSM7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 18 Jan 2012, Dave Airlie wrote:

>
> The problem is the x86 nvidia binary driver does sit outside of
> subsystems, and I forsee wanting to share buffers with it from the
> Intel driver in light of the optimus hardware. Although nouveau exists
> and I'd much rather nvidia get behind that wrt the kernel stuff, I
> don't forsee that happening.
>

Please correct me if I blab a nonsense here, but just the other day, we 
have seen a different thread in which it was decided that user cannot turn 
on buffer sharing at compile time explicitly, but rather a driver that 
needs it would turn it on automatically.

Doesn't that alone exclude out-of-tree drivers? In other words if you have 
two out-of-tree drivers that want to use DMA buffer sharing, and no other 
enabled driver in the kernel enables it implicitly, then such a kernel 
won't make it possible for said two drivers to work.

On a related note, EXPORT_SYMBOL_GPL will still happily link with 
out-of-tree driver, for as long as that driver comes under GPL-compatible 
license. So it's not really a question of whether the driver is 
out-of-tree or in-tree, but it's a question of driver's license.

Frankly, I never understood this "low-level interface" argument that is 
kicked around when EXPORT_SYMBOL_GPL topic is brought up. My view to 
EXPORT_SYMBOL vs. EXPORT_SYMBOL_GPL is that it really boils down to 
license controversy about binary/proprietary modules in Linux kernel. To 
me it's about whether the authors of certain code (for mostly 
phylosophical reasons) agree that their (GPL) code is OK or not OK to link 
against non-GPL module.

>From that angle, I am not sure if it is ethical at all to modify how the 
symbol is exported without explicit consent of the original author 
(regardless of what we think about GPL/proprietary modules covtroversy). 
So if NVidia needs to link DMA buffer sharing against their proprietary 
driver, they should have explicit permission from the original author to 
turn its symbols into EXPORT_SYMBOL.

-- Ilija

