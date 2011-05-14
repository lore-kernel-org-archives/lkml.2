Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab1ENQB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:01:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758334Ab1ENQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:01:26 -0400
Date: Sat, 14 May 2011 18:01:27 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Nori, Sekhar" <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Message-ID: <20110514160126.GA2791@opensource.wolfsonmicro.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <201105102344.58598.arnd@arndb.de>
 <82D549BB195345A1A189D569952B387C@subhasishg>
 <201105112203.54838.arnd@arndb.de>
 <EAA964D5CCD94B4A9544B294E0CF5099@subhasishg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAA964D5CCD94B4A9544B294E0CF5099@subhasishg>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 04:25:56PM +0530, Subhasish Ghosh wrote:

> >Instead, maybe you can simply call platform_device_register
> >at that stage to create the children and not use MFD at all.

> >Samuel, can you comment on this as well? Do you still see pruss
> >as an MFD driver when the uses are completely dynamic and determined
> >by the firmware loaded into it?

> But in that case, where do I fit my driver.
> It's a microcontroller inside of a processor, guess that's unique for Linux.

It's not that unusual in hardware terms, really.  There's an awful lot
of this going on in the audio area especially at the minute so there's
going to be some effort around providing some framework support for this
which should have some general usability but that's not there yet.

> Will a misc device be a better choice.

> In that case I can remove the MFD cell from the board_file and add an array
> of platform_device for the UART & CAN.

I think that for me so long as it can simultaneously do two unrelated
functions which need to be arbitrated between there's probably a place
for it in MFD, certainly at the minute.
