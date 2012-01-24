Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2AXDRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:17:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50272 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2AXDRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 22:17:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120106050355.GA7633@kroah.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
	<20120105223933.GA10268@kroah.com>
	<CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com>
	<20120106050355.GA7633@kroah.com>
Date: Tue, 24 Jan 2012 01:17:44 -0200
Message-ID: <CAOMZO5AO8TBm+C8LX97j=0SHUXEfcqb+VykBZhu8-ruazWD_3A@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
From: Fabio Estevam <festevam@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: netdev@vger.kernel.org, gwingerde@gmail.com, larry.finger@lwfinger.net,
        davem@davemloft.net, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 3:03 AM, Greg KH <greg@kroah.com> wrote:

> Then remove that selection.  Nothing should be depending on a misc
> driver,

Yes, this is the exact issue that this patch tries to solve.

Currently all of these are dependent on MISC_DEVICES being set.

source "drivers/misc/c2port/Kconfig"
source "drivers/misc/eeprom/Kconfig"
source "drivers/misc/cb710/Kconfig"
source "drivers/misc/iwmc3200top/Kconfig"
source "drivers/misc/ti-st/Kconfig"
source "drivers/misc/lis3lv02d/Kconfig"
source "drivers/misc/carma/Kconfig"
source "drivers/misc/altera-stapl/Kconfig"

With the patch applied it is possible to select all the drivers above
and we don't need to select MISC_DEVICES.

Regards,

Fabio Estevam
