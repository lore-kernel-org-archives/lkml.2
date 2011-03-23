Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1CWKca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:32:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1CWKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:32:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Wed, 23 Mar 2011 11:32:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
References: <4D79F068.2080009@linaro.org> <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk> <4D89C618.1020608@linaro.org>
In-Reply-To: <4D89C618.1020608@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231132.02690.arnd@arndb.de>
X-Provags-ID: V02:K0:LUZGaPb9QGHuO7fPUrQ6gcgzoZWDxQcPDRVYvcFKeqE
 BGbNDlqo47THO0UyuLyeWO1eceW98chn67bnqtifQPYhv9K+fP
 bhZPOptkIhnrGZqcDaN++fFCbHcL1uZuCecS571zyV4ftFJxao
 cNFu6CLro2UaD0T8N9YST2OZHuZlxCiKKkZPDt3hcJ2OQOPWk5
 RhumLCw2L/5+vRf5qytXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Andy Green wrote:
> It's the case for even usbnet, which is using a broken heuristic to 
> decide what to call the interface not even based on vid / pid.

I agree that the heuristics in usbnet is less than helpful here,
which among other things leads people to mixing up the two problems
of fixing the device naming and fixing the MAC address assignment.

Even though I know Greg disagrees, I'd still prefer sanitising the
rules for the default device name that usbnet assigns. Simply letting
a device driver flag "this is always an external ethernet, not
a point-to-point connection" would be enough to solve this problem,
and take some of the heat out of the discussion for how to solve
the MAC address assignment.

> Before this RFC there's no generic support for the concept, although 
> that hasn't stopped it being implemented in wl12xx already at individual 
> mainline driver level.  And before this RFC, I don't believe there was 
> any concept of async tagging through bus path for soldered-on assets in 
> Device Tree either.

For the device tree, the method has always been to assign the device_node
pointer to the device when the parent bus gets probed, that has not changed.
The new idea that came as a result of your RFC is to use the same mechanism
that we use elsewhere for USB as well, with the existing USB binding.

	Arnd
