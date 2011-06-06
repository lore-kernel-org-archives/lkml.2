Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1FFVBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:01:42 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:17400 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1FFVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:01:41 -0400
Message-ID: <4DED4030.9050503@tilera.com>
Date: Mon, 6 Jun 2011 17:01:36 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Timur Tabi <timur@freescale.com>, Deepak Saxena <dsaxena@linaro.org>,
        <kumar.gala@freescale.com>, <benh@kernel.crashing.org>,
        <greg@kroah.com>, <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106061803.58531.arnd@arndb.de> <4DECFBC5.6070205@freescale.com> <201106061824.53844.arnd@arndb.de>
In-Reply-To: <201106061824.53844.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2011 12:24 PM, Arnd Bergmann wrote:
> On Monday 06 June 2011, Timur Tabi wrote:.
>> And what about my concern that my driver will be the only one in drivers/virt?
> I have no doubt that more of these will come. Chris Metcalf is currently
> looking for a home for his tilera hypervisor drivers, and we have the
> microsoft hyperv drivers in drivers/staging, so they will hopefully
> move to a proper place later. We also have similar drivers in other
> places, e.g. drivers/ps3/ps3-sys-manager.c, drivers/s390/char/vmcp.c
> or parts of drivers/xen.

It might help if someone (Arnd?) wanted to propose a statement of what
drivers/virt was really for.  If it's for any Linux driver that upcalls to
a hypervisor for any reason, then the Tilera paravirtualized drivers fit in
well.  If it's intended more for drivers that guests running under a
hypervisor can use to talk to the hypervisor itself (e.g. managing
notifications that a hypervisor delivers to a guest to cause it to shut
down or take other actions), then it doesn't seem like the Tilera
paravirtualized device drivers belong there, since they're just using the
Tilera hypervisor synchronously to do I/O or get/set device and driver state.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


