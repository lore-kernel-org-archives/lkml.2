Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1EBVuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:50:18 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:33277 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157Ab1EBVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:50:17 -0400
Date: Mon, 2 May 2011 21:50:11 +0000 (UTC)
From: johnlinn@comcast.net
To: Arnd Bergmann <arnd@arndb.de>
Cc: nicolas pitre <nicolas.pitre@linaro.org>, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant likely <grant.likely@secretlab.ca>,
        john linn <john.linn@xilinx.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <1319927287.2232106.1304373011082.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <90477150.2231869.1304372815517.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Monday 02 May 2011 23:27:04 johnlinn@comcast.net wrote:
> > Yes we could explain hard coded numbers.  Ideally GIC driver would
> support
> > device tree it seems like to me.
> 
> > 
> > Seems like the GIC driver could remap it's own memory but maybe that
> won't
> > work across all platforms and then the platform would need to do
> it.
> 
> Why not just add a stub in the xilinx platform for now that remaps
> the
> memory using ioremap and calls the regular GIC initialization?

Seems easy enough assuming we don't need the SCU early for the core count
and can get that from the device tree.

Since the SCU and part of the GIC end up in the same 4K page they need to be
together (unless I'm thinking about that wrong).

SCU 0xF8000000
GIC_CPU 0xF8000100
GIC_DIS 0xF8001000

-- John

> 
> That function can then easily be moved to common code when another
> platform uses it.
> 
> 	Arnd
