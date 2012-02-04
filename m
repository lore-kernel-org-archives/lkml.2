Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2BDLwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 06:52:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38801 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2BDLwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 06:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120204105423.GA6693@lunn.ch>
References: <CAOA3yKLsecBx4aQ1Rvcw-VCa7JO-u-WNhTMdt9s+8trJWwpCeg@mail.gmail.com>
	<20120204105423.GA6693@lunn.ch>
Date: Sat, 4 Feb 2012 12:52:20 +0100
Message-ID: <CAOA3yKKnw2rcu7exJtx40aCX=c-DxEYg=HgnAsYf7Z1rfN64TQ@mail.gmail.com>
Subject: Re: PROBLEM: USB regression on TS-7800 board
From: Ambroz Bizjak <ambrop7@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: nico@fluxnic.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

your change fixes the problem; my board can again boot from my USB
stick (tested v3.0 and v3.2).
Thank you very much for the quick fix!

Best regards,
Ambroz

On Sat, Feb 4, 2012 at 11:54 AM, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sat, Feb 04, 2012 at 02:27:18AM +0100, Ambroz Bizjak wrote:
>> Hi,
>>
>> I've had problems with using newer Linux kernels with the TS-7800 ARM
>> board. Since kernel 3.0.0, USB storage devices are not recognized, and
>> errors are reported. See attachments for kernel output.
>
> Hi Ambroz
>
> Thanks for the regression report.
>
> I don't have any Orion5x hardware, i only have kirkwood based
> machines. So its very hard for me to test these changes.
>
> I've spotted one thing which looks wrong. Please could you test
> this. Its not a fix, just a proof i'm on the right track.
>
> In arch/arm/plat-orion/common.c
>
> /*****************************************************************************
>  * EHCI
>  ****************************************************************************/
> static struct orion_ehci_data orion_ehci_data = {
>        .phy_version    = EHCI_PHY_NA,
> };
>
> change this to
>
>        .phy_version    = EHCI_PHY_ORION.
>
> and see if the USB works then.
>
>    Thanks
>        Andrew
