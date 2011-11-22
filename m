Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1KVAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:09:58 -0500
Received: from mail.klingt.org ([86.59.21.178]:36654 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab1KVAJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:09:57 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Nov 2011 19:09:57 EST
From: Tim Blechmann <tim@klingt.org>
To: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Cc: Brian Gerst <brgerst@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [bisected] lx6464es fails to open a second time
Date: Tue, 22 Nov 2011 01:00:39 +0100
Message-ID: <2428359.JOQWRg64O4@moka>
User-Agent: KMail/4.7.3 (Linux/3.1.1+; KDE/4.7.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (klingt.org [86.59.21.178]); Tue, 22 Nov 2011 01:00:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all, especially brian and takashi,

some time ago, i've been developing the driver for the lx6464es ethersound 
sound card, which has been included into the kernel for some time. however i 
haven't been able to use it in kernels after 2.6.33.

today, i was able to bisect the issue and the first bad commit is:

commit 6175ddf06b6172046a329e3abfd9c901a43efd2e
Author: Brian Gerst <brgerst@gmail.com>
Date:   Fri Feb 5 09:37:07 2010 -0500

    x86: Clean up mem*io functions.
    
    Iomem has no special significance on x86.  Use the standard mem*
    functions instead of trying to call other versions.  Some fixups
    are needed to match the function prototypes.
    
    Signed-off-by: Brian Gerst <brgerst@gmail.com>
    LKML-Reference: <1265380629-3212-6-git-send-email-brgerst@gmail.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>


the problem was: the sound card could only be started once, but i haven't been 
able to start it a second time, probably because the driver doesn't shut down 
the device correctly.

the communication with the device is done by passing simple commands via 
memcpy_fromio and memcpy_toio (compare sound/pci/lx6464es/lx_core.c, lines 75 
to 99). any idea, what is going wrong there?

thanks, tim

