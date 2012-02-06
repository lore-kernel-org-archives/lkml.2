Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2BFTnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:43:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52883 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2BFTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:43:12 -0500
Date: Mon, 06 Feb 2012 14:42:56 -0500 (EST)
Message-Id: <20120206.144256.1171908949073473140.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: yevgenyp@mellanox.co.il, ogerlitz@mellanox.com, eugenia@mellanox.co.il,
        alexg@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mlx4: fix DMA mapping leak when allocation fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328553590-27677-2-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1328553590-27677-1-git-send-email-cascardo@linux.vnet.ibm.com>
	<1328553590-27677-2-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Feb 2012 11:42:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Mon,  6 Feb 2012 16:39:50 -0200

> mlx4_en_prepare_rx_desc does not correctly clean up after it finds an
> allocation failure. It should unmap a page before calling put_page, but
> it only calls the later.
> 
> This bug would prevent a device removal using hotplug after setting the
> device MTU to 9000 and opening the network interface. After the fix, we
> still see the allocation failure with MTU 9000, but we are able to
> remove the device.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied.
