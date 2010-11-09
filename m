Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0KIROy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:14:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47093
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab0KIROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:14:52 -0500
Date: Tue, 09 Nov 2010 09:15:16 -0800 (PST)
Message-Id: <20101109.091516.112581012.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v15 00/17] Provide a zero-copy method on KVM virtio-net.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
References: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Tue,  9 Nov 2010 17:03:05 +0800

> We provide an zero-copy method which driver side may get external
> buffers to DMA. Here external means driver don't use kernel space
> to allocate skb buffers. Currently the external buffer can be from
> guest virtio-net driver.

1) Please use kernel-doc style comments to document structure
   members.

2) The idea to key off of skb->dev in skb_release_data() is
   fundamentally flawed since many actions can change skb->dev on you,
   which will end up causing a leak of your external data areas.
