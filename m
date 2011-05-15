Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1EOJdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 05:33:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1EOJdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 05:33:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Sun, 15 May 2011 11:33:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105142233.53659.arnd@arndb.de> <20110514221445.GB21792@opensource.wolfsonmicro.com>
In-Reply-To: <20110514221445.GB21792@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105151133.23870.arnd@arndb.de>
X-Provags-ID: V02:K0:6D6OQpNnJIfyhlKVQwoCy4lqh4vCTqQSpqMS9Hlhjov
 2Hd55PTJv91ljcGtJ0PK8VdYDK6DHhPB5bAG4RYCXyci1j8cax
 CFeth64/LHBad29AEQUdZGRMoTN8r9+JfQYUz8o1BtUa/cenHa
 NEhHZ3zDybZC8DRP4PLDjY9r/YhsqbgqmteAp3BLSWq26/whj0
 u5wDCqFEQCUx4ov/DnbkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 May 2011, Mark Brown wrote:
> > My whole point has been that you register them from the main pruss driver
> > based on run-time data instead of compile-time pre-configured stuff in the
> > board file.
> 
> I'm not so sure - if the usage is fixed as a result of the pins on the
> device being wired a CAN bus then it seems reasonable to tell the system
> about that so it'll stop the user trying to run SPI or something against
> it at runtime.

I'm mostly worried about the case where the pins are not hardwired for
some specific function -- Subhasish was mentioning that these may be
implemented using a pluggable extension board and I want to make sure
that you are not required to recompile the kernel when changing the
extension board.

However, you made a good point that in many cases it will be hardwired
so it may be valuable to preconfigure this in a way that does not require
scripts to set up variables in sysfs when you already know what is there.

Note that my suggestion to put the device name into the firmware file
covers this case, because you can then simply ship a firmware blob that
matches the hardware configuration. Thinking about the future device
tree setup, you can even put the firmware blob itself into a property
in the device tree file.

	Arnd
