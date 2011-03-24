Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1CXNof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:44:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44791 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1CXNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=fV4fGevupvI54FBh3mkmD2FcFr1k2zb8AUF6Gep1pWwL/DJnDn3/R3RwikcdOqcOPK
         IcgWtnWRnNa96eQMQmpPyeiwiUSc+lAmHeA8WOM54a8TWQUv2YaDGfyME5aHjTOjUWxd
         zCGZyGotE3ob4GQLbAm5ZHhFz10N2tK9Vi6HI=
Message-ID: <4D8B4ABC.9090203@linaro.org>
Date: Thu, 24 Mar 2011 13:44:28 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Ben Hutchings <bhutchings@solarflare.com>,
        Steve Calfee <stevecalfee@gmail.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>,
        patches@linaro.org
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
References: <4D79F068.2080009@linaro.org> <1300924878.2638.38.camel@bwh-desktop> <201103241413.54599.arnd@arndb.de> <201103241415.45115.arnd@arndb.de>
In-Reply-To: <201103241415.45115.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 01:15 PM, Somebody in the thread at some point said:
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
> point-to-point link with the new FLAG_PTP setting in the usbnet
> driver_info. A driver can set both FLAG_PTP and FLAG_ETHER if
> it is not sure (e.g. cdc_ether), or just one of the two.
> The usbnet framework only looks at the MAC address for device
> naming if both flags are set, otherwise it trusts the flag.
>
> Signed-off-by: Arnd Bergmann<arnd.bergmann@linaro.org>
> Cc: Andy Green<andy.green@linaro.org>
> Cc: patches@linaro.org

For Panda case at least,

Tested-by: Andy Green <andy.green@linaro.org>

-Andy
