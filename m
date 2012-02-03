Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2BCWum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:50:42 -0500
Received: from xes-mad.com ([216.165.139.218]:4613 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab2BCWul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:50:41 -0500
Date: Fri, 03 Feb 2012 16:50:28 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: guenter roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <eab6c0bf-4908-454c-b7fa-606e70050793@zimbra>
In-Reply-To: <1328298346.2261.196.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you want to send me your patchset directly, I can test it out on
> > some of our hardware (Ibex Peak and Cougar Point). I can work on
> > implementing some of your other suggestions as well before
> > resubmitting to the list.
> > 
> Done. You should have received a series of four patches, your three
> plus one with a number of changes I made on top of your first patch.
> The last two patches are essentially yours modified to compile with
> 3.3-rc2 and to work (hopefully ;) with my patch.
> 
> Thanks,
> Guenter

Guenter,
I received and applied your patches. I had to compile with ACPI
disabled because 3.3-rc2 now reports a resource conflict between the
WDAT structure (that we report for Microsoft Windows watchdog timer
support) and the TCO watchdog portion of lpc_ich:

ACPI Warning: 0x00000460-0x0000047f SystemIO conflicts with
Region \PMIO 1 (20120111/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
lpc_ich: probe of 0000:00:1f.0 failed with error -16

We may have to submit a driver in the future to utilize the WDAT
ACPI table, but that's another topic.

Do you think it's worth modifying lcp_ich to register all of the
resources that it can and only populate the mfd_cells that have
all of their required resources? That would prevent the entire
driver from bombing out in situations like this. I can't imagine
our BIOS is the only one implementing the WDAT table.

Anyway, after compiling without ACPI the lpc_ich driver registered
as expected and the gpio-ich and iTCO_wdt drivers detected and
configured their associated resources. I have verified that the
watchdog timer still works as expected. I need to track down some
other hardware to properly test the GPIO.

-Aaron
