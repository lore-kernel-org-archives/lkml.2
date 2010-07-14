Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0GNLVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:21:09 -0400
Received: from mta-mad.optenet.com ([130.117.93.253]:52174 "EHLO
	mta-mad.optenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0GNLVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:21:07 -0400
X-Greylist: delayed 1845 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 07:21:07 EDT
Date: Wed, 14 Jul 2010 12:50:18 +0200 (CEST)
From: Unai Uribarri <unai.uribarri@optenet.com>
To: linux-kernel@vger.kernel.org
Message-ID: <7112439.65171279104617973.JavaMail.root@mail1-md.optenet.com>
In-Reply-To: <3152203.65151279104029659.JavaMail.root@mail1-md.optenet.com>
Subject: Workaround hardware bug addressing physical address
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.3.29]
X-Mailer: Zimbra 5.0.11_GA_2695.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/5.0.11_GA_2695.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I'm writing a device driver for a Cavium Octeon 56xx network adapter, which has a silicon bug: it sends invalid PCI Express TLP headers when writing to physical addresses between 2GB and 4GB. It sends a 64 bit memory write when the PCI specs mandates a 32 bit memory write, and some PCIe bridges refuses such transactions (at least Intel 5520/X58 refuses them). 

Now, when allocating memory using alloc_page, I check the allocated memory and leak the unusable pages. This "solution" works but I'm leaking huge amounts of memory, so I'm planning to adopt a more elegant solution. I'm going to link together all the unusable pages and, after all the memory is allocated, free the unusable pages.

Do someone knows if more hardware shares this bug? Will a generic solution be useful for other hardware that doesn't accept certain zones of memory? Has anyone already developed such solution?

Thanks.
