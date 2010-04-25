Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0DYJz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:55:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51743
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193Ab0DYJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:55:24 -0400
Date: Sun, 25 Apr 2010 02:55:29 -0700 (PDT)
Message-Id: <20100425.025529.123989625.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, jdike@linux.intel.com
Subject: Re: [RFC][PATCH v4 00/18] Provide a zero-copy method on KVM
 virtio-net.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272187206-18534-19-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-17-git-send-email-xiaohui.xin@intel.com>
	<1272187206-18534-18-git-send-email-xiaohui.xin@intel.com>
	<1272187206-18534-19-git-send-email-xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Sun, 25 Apr 2010 17:20:06 +0800

> The idea is simple, just to pin the guest VM user space and then let
> host NIC driver has the chance to directly DMA to it.

Isn't it much easier to map the RX ring of the network device into the
guest's address space, have DMA map calls translate guest addresses to
physical/DMA addresses as well as do all of this crazy page pinning
stuff, and provide the translations and protections via the IOMMU?

What's being proposed here looks a bit over-engineered.
