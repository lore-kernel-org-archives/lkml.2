Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1HPTHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:07:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1HPTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:07:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@xenotime.net>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/4] msm_serial: Add devicetree support
Date: Tue, 16 Aug 2011 21:07:08 +0200
Message-ID: <3445697.36l0oAAgCs@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110816175702.GA27576@huya.qualcomm.com>
References: <1313190008-7551-1-git-send-email-davidb@codeaurora.org> <65679699.l4XXDScc0T@wuerfel> <20110816175702.GA27576@huya.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wgsl0qQNUiS6Xa9FRP3sOhehnWj6/1fCXYYqafWp9Ng
 S0B/Wm996zIYETB81at1x9OwQVPsKjQwL6x8d8VAjg0j54lCJN
 X0ZmS3PlKxGmAcSxoN1k5bZS3oHtrhUmgzew4dGYiU14U4TAYG
 IF0kq82BJejqJRd6PcJtGiHiNUgLb023Y50ViUZo/+ULEuE0X+
 ZZXbKaMixilytzRGTAiEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011 10:57:02 David Brown wrote:
> How about if I just keep it simple for now.  Since there isn't
> actually a driver for the DMA version, this driver will handle both
> UART blocks, so I'll just do the plain thing in the DT.

Sounds good to me.

> In the future, when a DMA-capable driver exists, we can figure out how
> to determine which driver should be used.  At this point, I'm not even
> sure what the correct answer will be, since a given configuration may
> want to use non-DMA for one msm-hsuart device, and the DMA driver for
> another.  It's kind of board/use specific, but beyond just describing
> what the hardware is.

In order to be absolutely future-proof, you could mandate that you always
list two "compatible" values, one for the generic version and one for
the specific implementation (high-speed or low-speed). It's a simple
change from what you have now and it allows to change the drivers to
bind to just the specific name in case you want to handle them separately
in the future, without having to change the device tree files.

	Arnd
