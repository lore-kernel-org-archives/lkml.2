Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0LGQSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:18:31 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:53665 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0LGQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:18:30 -0500
Date: Tue, 7 Dec 2010 17:18:27 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost6.localdomain6
To: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
cc: linux-kernel@vger.kernel.org
Subject: [RFC] bind/unbind uevent
Message-ID: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is currently no generic trigger for userspace to know when a driver
is bound to a device. Such a trigger may be required in cases where setup
steps must be performed in userspace after the device is bound, e.g.
because the driver adds sysfs attributes in its probe function.

I can imagine 3 possible ways to solve this problem:
* add a bus specific change event (triggered by BUS_NOTIFY_BOUND_DRIVER)
  - this may result in duplicated code for each bus
* dissable autoprobing and "manually" probe the device from userspace
  triggered by the add event - this duplicates logic already implemented
  in the kernel
* add a generic bind/unbind uevent

Which one is preferred from a driver core perspective?

Regards,
Sebastian
