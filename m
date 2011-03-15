Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab1CONHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:07:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab1CONHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:07:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Date: Tue, 15 Mar 2011 14:07:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
References: <4D7F356C.8020903@cn.fujitsu.com> <201103151302.09381.arnd@arndb.de> <20110315121941.GD2167@linux.vnet.ibm.com>
In-Reply-To: <20110315121941.GD2167@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151407.24800.arnd@arndb.de>
X-Provags-ID: V02:K0:qY7HHRTRqumiSSBexokw+UhtrFBcJm01D/jcBqaPVDN
 8gv60m7fFzTyKKpD8/CHOBGc1/NhnndqWF2h8ti38HC7GNl7NI
 TJ12Gulv7BKiSIjrVEuxfX+GE1idSL52jZ/ybm6P5rQdpHYfys
 9kx117WBhpl+xJzW5YFRB5actcbGoC+FyKurj6ZRfW5xrtV1zy
 eTToD7Zsm0+4khL7/lCRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Paul E. McKenney wrote:
> And it makes use of statically allocated structures a bit clunky.

How do statically allocated structures relate to this? I would
expect that you never call kfree_rcu on them, so it shouldn't
matter.

> Yet another approach is to use the low-order bit of the rcu_head pointer,
> given that the rcu_head structure does have to be aligned.  If this bit
> is set, then the function pointer could be interpreted as an offset.
> This approach might also allow a slab_free_rcu() to be constructed, given
> that the full 32 bits of the function pointer would be available.
> For example, if the upper 16 bits are zero, the low-order 16 bits are
> the offset.  If the upper 16 bits are 0x1, then the low-order 16 bits
> might be an index that selects the desired slab cache.

This solution sounds like a clear improvement over the patch that Lai
Jiangshan posted, without any downsides.

	Arnd
