Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab0FCJY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:24:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:64612 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab0FCJY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=QLVINK19Wj6yXs45lNSR2x8DJYybh7ZruWQRHciOJNrwrDRh9QtlQ2JIUemFlBoI4z
         RiuSguS/kqdx38h4iPzeCZ32NRa6/pOc4Hin8XFcyYjOQGtJlqbbdNq5r8VJlXRyJam+
         k817aXeTPZzhygILsQlaqTvq58V8K9A9vLIKE=
Message-ID: <4C0774C6.4090000@suse.cz>
Date: Thu, 03 Jun 2010 11:24:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100527 SUSE/3.1rc1-3.3 Thunderbird/3.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, achiang@hp.com
Subject: cpqphp: NULL ptr deref in cpqhpc_probe
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have a system where there is a pci hotplug class device to be handled
by cpqphp, but it is not a bridge. But in cpqhpc_probe there is:
struct pci_bus *bus;
...
bus = pdev->subordinate;
...
bus->max_bus_speed = PCI_SPEED_66MHz_PCIX;

But as it is not a bridge, subordinate is NULL and the kernel crashes.

Any idea what would be a correct fix here?

The bugzilla entry is at:
https://bugzilla.novell.com/show_bug.cgi?id=609338

thanks,
-- 
js
suse labs
