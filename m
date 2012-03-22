Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031519Ab2CVXfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:35:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48045 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031478Ab2CVXe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:34:59 -0400
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX1/FW/ByNN7F06Nfjdf5fsaUlBr4gbaRWkqGaW7/SS
	J+9rzq1Oa/72NZ
Date: Fri, 23 Mar 2012 00:34:56 +0100
From: Michael Brunner <mibru@gmx.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] pch_uart: Add Kontron COMe-mTT10 uart clock quirk
Message-ID: <20120323003456.6f7fea2e@mail.gmx.de>
In-Reply-To: <4F6B9E7B.9090005@linux.intel.com>
References: <20120322211903.6776ab18@mail.gmx.de>
	<4F6B8E1B.9080802@linux.intel.com>
	<20120322223112.291e0c59@mail.gmx.de>
	<4F6B9E7B.9090005@linux.intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, my board has DMI_BOARD_NAME as:
> 
> "nETXe-TT 1.0GHz E2 KDMS-FRI" but will also undergo a rename in the
> near future. I'm concerned about colliding as I believe this kit may
> use the same board you are working with. This COM Express module will
> be renamed "COMe-mTT10" which will match your strstr compare.

You are right, the development kit uses a customized version of the
COMe-mTT10.

> So what does your DMI_BIOS_VERSION report?

The BIOS for the stock COMe-mTT10 is prefixed with NTC1.

> I didn't like basing this on BIOS_VERSION, but I did so at Kontron's
> preference. Now we're seeing the fallout (sooner than I expected).

Basically this is not a wrong decision, as the FRI2 project code is
unique for the firmware used on the development kit.

> So the question is, do we treat these as separate devices (the board
> and the development kit which I believe includes your board) or do we
> lump them together.

To be safe we should treat them as separate devices and make sure we
are able to differentiate between them.

> Since it is the firmware that ultimately decides what the initial
> UARTCLK is, we can't base this on the hardware alone. The hardware in
> fact should be default if a firmware match isn't found first. So, my
> preference would be that you move your new comparison AFTER the FRI2
> DMI_BIOS_VERSION comparison. This ensures the FRI2 doesn't match your
> new comparison which might get a different UARTCLK in the future for
> whatever reason.

I understand your concerns and agree with you that in this case the BIOS
version should be checked before the board name, same goes for the
product name. So I will prepare a new patch that puts my BOARD_NAME
comparison to the end.

Michael
