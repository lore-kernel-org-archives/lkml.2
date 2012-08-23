Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab2HWVJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:09:11 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:65090 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934412Ab2HWVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:09:07 -0400
Message-ID: <1345756142.2579.16.camel@bwh-desktop.uk.solarflarecom.com>
Subject: RE: [PATCH v2] net: add new QCA alx ethernet driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Huang, Xiong" <xiong@qca.qualcomm.com>
CC: David Miller <davem@davemloft.net>, "Ren, Cloud" <cjren@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Date: Thu, 23 Aug 2012 22:09:02 +0100
In-Reply-To: <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
	 <20120822.225700.714020017287504609.davem@davemloft.net>
	 <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 06:35 +0000, Huang, Xiong wrote:
> > This is why we require that portable, sane, interfaces are added to ethtool for
> > driver diagnostics.  That way users can perform a task in the same way
> > regardless of what hardware and driver are underneath.
> 
> I quite agree you on using ethtool to implement it. we did consider it. 
> But ethtool has some limitation, for example, the NIC has built-in OTP (TWSI interface)
> And Flash (External SPI interface),  their properties are quite different with EEPROM which
> Ethtool supports.
> To support such memory (OTP/Flash), we need additional input parameters.

You have two reasonable options for this:
1. The ETHTOOL_FLASHDEV command takes a partition ID and filename to
write.  The driver is supposed to load the file through the firmware
loader and then rewrite the partition completely (erasing if necessary).
Example: be2net.
2. For a more flexible interface, implement an MTD driver as part of
your net driver.  Example: sfc.

> Same situation exists in diagnostic utility. Ethtool only provide two options : offline & online
> That's too gross to locate which part/module of the chip is malfunction. we also need 
> more options to detect it.

That's absolute nonsense, you can run as many sub-tests as you want and
provide separate results for each of them.

Ben.

> that's why we finally selected a custom debugfs interface. 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

