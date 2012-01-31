Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2AaSSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:18:01 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:39639 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab2AaSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:17:59 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] smsc95xx: add macaddr module parameter
Date: Tue, 31 Jan 2012 19:17:11 +0100
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1328030433-12524-1-git-send-email-danny.kukawka@bisect.de> <20120131172731.03df5704@pyramind.ukuu.org.uk>
In-Reply-To: <20120131172731.03df5704@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201311917.12534.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328033879;e1f22c40;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 31. Januar 2012, Alan Cox wrote:
> On Tue, 31 Jan 2012 18:20:33 +0100
>
> Danny Kukawka <danny.kukawka@bisect.de> wrote:
> > Added smsc95xx.macaddr module parameter to allow the user to
> > change the MAC address on boot if there was no MAC on the EEPROM.
>
> NAK. Please see the discussion on this and ifconfig hw for other devices.
>
> In summary - make the device refuse to ifconfig up without a valid
> address, allow it to come into existance without a valid address and then
> use ifconfig.
>
>
> Your patch also seems to break if there are several attached to a board.

There are already other kernel driver which allow to override the (hw) MAC 
address via a module parameter (macaddr): 
- KSZ8841/2 PCI network driver (drivers/net/ethernet/micrel/ksz884x.c)
- FEC Ethernet driver (drivers/net/ethernet/freescale/fec.c)
- Sun HappyMealEthernet(HME) 10/100baseT ethernet driver
  (drivers/net/ethernet/sun/sunhme.c)

By default the MAC from the module parameter get only assigned to the first 
device which got a random MAC (caused by missing EEPROM) before. If you have 
more than one device you can simply assign the MAC to a specific interface 
(e.g. use: macaddr=01:23:45:67:89:ab;eth0). If there are only devices with 
hardware MAC nothing will get changed.

Danny
