Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab2AEWme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:42:34 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60249 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932371Ab2AEWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:42:33 -0500
X-Sasl-enc: Q/mmZIUiED02MF4EJ1xZXuEiekou7i2N/sxbwa4gBGe9 1325803352
Date: Thu, 5 Jan 2012 14:39:33 -0800
From: Greg KH <greg@kroah.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: netdev@vger.kernel.org, gwingerde@gmail.com, larry.finger@lwfinger.net,
        davem@davemloft.net, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
Message-ID: <20120105223933.GA10268@kroah.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325796541-11402-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 06:49:01PM -0200, Fabio Estevam wrote:
> MISC_DEVICES option alone does not select any kernel code and can cause dependency build warnings, such as:
> 
> warning: (KS8851 && AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
> 
> Remove MISC_DEVICES option so that any dependency on this symbol is avoided.

Are you sure that this isn't getting confused with the
drivers/char/misc.c interface instead of the "throw a bunch of randome
drivers into drivers/misc/" issue?

Why would anything ever want to select MISC_DEVICES?  What happens if
you just remove that select line from the Kconfig?

thanks,

greg k-h
