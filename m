Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0FCADF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:03:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45615 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab0FCADC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=jZyyp4M7D9mNa9VTdQ8WEHqcI3iKx3dGilxM8+YZ3UlZEX6Y7san6L9ryP/SHhyAqP
         fRVRIXiD2Bd6Zt4IKk8srQDUHNtBoFfusVhnswV7p7NRgzxt5oZ8bXLK10fZlNVn50Yn
         UtC8PX6R9mrsJnYW9PA0kLJJEv6YdvRK+P4qs=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: [URGENT] Re: bit errors on spitz + voipac
Date: Thu, 3 Jun 2010 02:01:13 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2-amd64; KDE/4.4.2; x86_64; ; )
Cc: Cyril Hrubis <metan@ucw.cz>, Stanislav Brabec <utx@penguin.cz>,
       Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       arminlitzel@web.de, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       Haojian Zhuang <haojian.zhuang@gmail.com>
References: <20100305212708.GC21773@elf.ucw.cz> <1268048916.6477.9.camel@utx.utx.cz> <20100308121634.GA14904@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100308121634.GA14904@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006030201.13341.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 8. března 2010 13:16:35 Cyril Hrubis napsal(a):
> Hi!
> 
> > - And I see display noise while CF Wi-Fi card is active.
> 
> Forgotten about this one. See for yourself, notice short black vertical
> lines flashing randomly.
> 
> http://atrey.karlin.mff.cuni.cz/~metan/outgoing/zaurus_sickness.mpg

This is not only case of spitz. I've seen LCD image falling apart on pxafb on 
Voipac PXA270 board. The image was like "torn in half and part of it was moved 
to right, the hole between staying white".

This happened exactly when I started doing a DMA transfer from a harddrive 
attached through pata_pxa. It's perfectly replicable. If I disabled DMA and let 
it run only in PIO, the image was fine.

I assume the corruption Pavel was seeing is related. My guess is the problems 
are caused when DMA between the CPU and a companion chip happens. I dunno if the 
DMA controller doesn't have enough power to supply LCD and the companion chip 
with data, but that's one of my guesses.

btw. Adjusting the DMA descriptor length in pata_pxa didn't help.

Guys, we need to investigate this as it seems to cause problems on many places.

Cheers!
