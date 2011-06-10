Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab1FJORa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:17:30 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:59336 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab1FJOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:17:27 -0400
Message-ID: <4DF22770.4010103@tilera.com>
Date: Fri, 10 Jun 2011 10:17:20 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linuxppc-dev@lists.ozlabs.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Timur Tabi <timur@freescale.com>, <konrad.wilk@oracle.com>,
        <kumar.gala@freescale.com>, <linux-kernel@vger.kernel.org>,
        <akpm@kernel.org>, <dsaxena@linaro.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com> <201106090938.23027.arnd@arndb.de>
In-Reply-To: <201106090938.23027.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/2011 3:38 AM, Arnd Bergmann wrote:
> On Thursday 09 June 2011 01:10:09 Randy Dunlap wrote:
>> On Wed, 8 Jun 2011 17:45:54 -0500 Timur Tabi wrote:
>>
>>> Add the drivers/virt directory, which houses drivers that support
>>> virtualization environments, and add the Freescale hypervisor management
>>> driver.
>> It can't go in linux/virt or linux/virt/fsl instead?  why drivers/ ?
>>
>> or maybe linux/virt should be drivers/virt ?
> See discussion for v2 of this patch. I suggested that drivers/firmware and virt/
> as options, the counterarguments were that drivers/firmware is for passive
> firmware as opposed to firmware that acts as a hypervisor, and that virt/ is
> for the host side of hypervisors like kvm, not for guests.
>
> The driver in here most closely resembles the xen dom0 model, where a
> priviledged guest controls other guests, but unlike xen there is a single
> driver file, so there is no need to have drivers/fsl-hv directory just
> for this one file. We do have a number of other hypervisors that fit in the
> same category, so they can be added here later.

This still leaves open the question of what really should go in this new
directory. Is it just for drivers that manage/control the hypervisor?  Or
is it also for drivers that just use the hypervisor to do I/O of some kind,
but aren't related to any other "family" of drivers, i.e., a driver that
would have been dumped in drivers/char or drivers/misc in the old days?

My specific interest at the moment is the proposed tile-srom.c driver
(https://patchwork.kernel.org/patch/843892/), which uses a simple
hypervisor read/write API to access the portion of the SPI ROM used to hold
the boot stream for a TILE processor.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


