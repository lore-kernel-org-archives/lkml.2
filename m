Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1HLLXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 07:23:45 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:48506 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1HLLXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 07:23:44 -0400
Message-ID: <4E450E39.3030404@ladisch.de>
Date: Fri, 12 Aug 2011 13:27:53 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Pecker Hu <pecker.hu@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Need help about how linux to handle translation fault
References: <CAPtRRT9h6yWNB41tfjO9ryx+BppkiTGNWRgNjNTUkwXv-B0eYw@mail.gmail.com>
In-Reply-To: <CAPtRRT9h6yWNB41tfjO9ryx+BppkiTGNWRgNjNTUkwXv-B0eYw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pecker Hu wrote:
> ...
> And I send the address of str to kernel space using IOCTL interface.
> ioctl(fd, VM_TEST_GET_VADDR, str);
> 
> When I try to use pgd to find the physical address, I don't find it
> .

You must not directly access user space memory from kernel space because
that memory can be moved or swapped out at any time.  Use only functions
like copy_from_user() which take appropriate precautions; and don't
forget to check for errors.

Furthermore, the physical address is useless.  If you want to access
the memory from a device, you have to use the DMA mapping API because
the CPU's physical address it not necessarily the same address as that
used on the device's bus, and sometimes you have to program an IOMMU
before devices are allowed to access that memory at all.

> So I think string array is located in data cache not in physical
> memory, after I call copy_from_user, kernel will allocate page for it,
> then we can access it, is it right?

As far as any code running on the CPU is concerned, caches are
completely transparent.  (This is not always true for devices, but the
DMA mapping API takes care of that.)


Regards,
Clemens
