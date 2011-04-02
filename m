Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1DBDMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 23:12:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37403
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab1DBDMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 23:12:54 -0400
Date: Fri, 01 Apr 2011 20:12:16 -0700 (PDT)
Message-Id: <20110401.201216.48508539.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        dbrownell@users.sourceforge.net, patches@linaro.org, greg@kroah.com,
        nicolas.pitre@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usbnet: use eth%d name for known ethernet devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <201104011706.36873.arnd@arndb.de>
References: <201104011706.36873.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 1 Apr 2011 17:06:36 +0200

> The documentation for the USB ethernet devices suggests that
> only some devices are supposed to use usb0 as the network interface
> name instead of eth0. The logic used there, and documented in
> Kconfig for CDC is that eth0 will be used when the mac address
> is a globally assigned one, but usb0 is used for the locally
> managed range that is typically used on point-to-point links.
> 
> Unfortunately, this has caused a lot of pain on the smsc95xx
> device that is used on the popular pandaboard without an
> EEPROM to store the MAC address, which causes the driver to
> call random_ether_address().
> 
> Obviously, there should be a proper MAC addressed assigned to
> the device, and discussions are ongoing about how to solve
> this, but this patch at least makes sure that the default
> interface naming gets a little saner and matches what the
> user can expect based on the documentation, including for
> new devices.
> 
> The approach taken here is to flag whether a device might be a
> point-to-point link with the new FLAG_POINTTOPOINT setting in
> the usbnet driver_info. A driver can set both FLAG_POINTTOPOINT
> and FLAG_ETHER if it is not sure (e.g. cdc_ether), or just one
> of the two.  The usbnet framework only looks at the MAC address
> for device naming if both flags are set, otherwise it trusts the
> flag.
> 
> Signed-off-by: Arnd Bergmann <arnd.bergmann@linaro.org>
> Tested-by: Andy Green <andy.green@linaro.org>

Applied, thanks.
