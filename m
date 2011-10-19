Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1JSGvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:51:46 -0400
Received: from lvk-gate.cmc.msu.ru ([212.192.248.233]:40491 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753037Ab1JSGvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:51:45 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Oct 2011 02:51:45 EDT
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-kernel@vger.kernel.org
Subject: high-order allocation + highmem + streaming DMA - possible?
Date: Wed, 19 Oct 2011 10:45:40 +0400
User-Agent: KMail/1.9.9
Cc: stefan@lvk.cs.msu.su
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201110191045.42613@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

We are writing a driver for a custom PCI device that receives large amount 
of data.

Device is capable of DMAing received data in 64k chunks.

We have been going to:
- use physically-continuous 64k-sized memory areas using alloc_pages() with 
order=4,
- allocate large number of such areas on driver init,
- implement mmap() to map those all to userspace for zero-copy processing,
- use streaming DMA to actually receive data

However I can't find a way to use streaming DMA for large highmem areas.
- pci_map_single() is for linear mapping and can't work with highmem
- pci_map_page() can work with highmem but is limited to one page
- pci_map_sg() is for s/g lists, not for single 64k blocks.

Is there a way to use streaming DMA with large memory areas located in 
highmem?
Or in this situation buffers in highmem can't be used?

Nikita
