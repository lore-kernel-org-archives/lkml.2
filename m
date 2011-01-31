Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1AaP5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:57:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab1AaP5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:57:06 -0500
Date: Mon, 31 Jan 2011 10:54:12 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>
Subject: b44 driver causes panic when using swiotlb
Message-ID: <20110131105412.7252a09c@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The b44 driver is triggering this panic in swiotlb_map_page():

        if (!dma_capable(dev, dev_addr, size))
                panic("map_single: bounce buffer is not DMA'ble");

The kernel log says the bounce buffers are at 0xdb400000, but b44 can
only do DMA to the first 1GB of memory:

 PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
 Placing 64MB software IO TLB between ffff8800db400000 - ffff8800df400000
 software IO TLB at phys 0xdb400000 - 0xdf400000
