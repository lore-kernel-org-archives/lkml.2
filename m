Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2BDLOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 06:14:25 -0500
Received: from londo.lunn.ch ([80.238.139.98]:56573 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab2BDLOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 06:14:23 -0500
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Feb 2012 06:14:23 EST
Date: Sat, 4 Feb 2012 11:54:23 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Ambroz Bizjak <ambrop7@gmail.com>
Cc: andrew@lunn.ch, nico@fluxnic.net, tzachi@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: USB regression on TS-7800 board
Message-ID: <20120204105423.GA6693@lunn.ch>
References: <CAOA3yKLsecBx4aQ1Rvcw-VCa7JO-u-WNhTMdt9s+8trJWwpCeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOA3yKLsecBx4aQ1Rvcw-VCa7JO-u-WNhTMdt9s+8trJWwpCeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 02:27:18AM +0100, Ambroz Bizjak wrote:
> Hi,
> 
> I've had problems with using newer Linux kernels with the TS-7800 ARM
> board. Since kernel 3.0.0, USB storage devices are not recognized, and
> errors are reported. See attachments for kernel output.

Hi Ambroz

Thanks for the regression report.

I don't have any Orion5x hardware, i only have kirkwood based
machines. So its very hard for me to test these changes.

I've spotted one thing which looks wrong. Please could you test
this. Its not a fix, just a proof i'm on the right track.

In arch/arm/plat-orion/common.c

/*****************************************************************************
 * EHCI
 ****************************************************************************/
static struct orion_ehci_data orion_ehci_data = {
        .phy_version    = EHCI_PHY_NA,
};

change this to 

        .phy_version    = EHCI_PHY_ORION.

and see if the USB works then.

    Thanks
	Andrew
