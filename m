Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0KJRqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:46:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52630
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab0KJRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:46:17 -0500
Date: Wed, 10 Nov 2010 09:46:41 -0800 (PST)
Message-Id: <20101110.094641.193701683.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v15 00/17] Provide a zero-copy method on KVM virtio-net.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289381008-5484-1-git-send-email-xiaohui.xin@intel.com>
References: <20101109.091516.112581012.davem@davemloft.net>
	<1289381008-5484-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Wed, 10 Nov 2010 17:23:28 +0800

> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
>>2) The idea to key off of skb->dev in skb_release_data() is
>>   fundamentally flawed since many actions can change skb->dev on you,
>>   which will end up causing a leak of your external data areas.
> 
> How about this one? If the destructor_arg is not a good candidate,
> then I have to add an apparent field in shinfo.

If destructor_arg is actually a net_device pointer or similar,
you will need to take a reference count on it or similar.

Which means --> good bye performance especially on SMP.

You're going to be adding new serialization points and at
least two new atomics per packet.
