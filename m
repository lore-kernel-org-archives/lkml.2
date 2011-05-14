Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab1ENUeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:34:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1ENUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:34:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Sat, 14 May 2011 22:33:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <EAA964D5CCD94B4A9544B294E0CF5099@subhasishg> <20110514160126.GA2791@opensource.wolfsonmicro.com>
In-Reply-To: <20110514160126.GA2791@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105142233.53659.arnd@arndb.de>
X-Provags-ID: V02:K0:JULmrQqVc7DUAN1l3S0wXYfA8ngnx7GHga5Ygj5ohHT
 MnS+bi9hWj6n2DRYOrds6RUvCQJw/NyxeqFNdubtz4u9bLPP2K
 Lj+rxicP8coDEl1o2hc9mWN0+tUATiQqTiABKbTI/y7NKT3VkL
 a6xrbM60H/OxDih8rjIU1VyV8lAcGntZ04NOdPbk9lqPFa6cKG
 C8Lhtf1UV4DEqHlqBUImg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 May 2011, Mark Brown wrote:
> > Will a misc device be a better choice.
> 
> > In that case I can remove the MFD cell from the board_file and add an array
> > of platform_device for the UART & CAN.
> 
> I think that for me so long as it can simultaneously do two unrelated
> functions which need to be arbitrated between there's probably a place
> for it in MFD, certainly at the minute.

I guess drivers/mfd would be a better place than drivers/misc, but it might not
need to be an mfd driver in the sense that it registers mfd cells.

The more important point is to remove the device registration from the board
file. You definitely should not have the cells in the board file, but replacing
them with platform devices in the board file makes it no better.

My whole point has been that you register them from the main pruss driver
based on run-time data instead of compile-time pre-configured stuff in the
board file.

	Arnd
