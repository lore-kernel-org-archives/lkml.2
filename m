Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0E0BWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:22:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:13567 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab0E0BWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,308,1272870000"; 
   d="scan'208";a="281832142"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Date: Thu, 27 May 2010 09:21:02 +0800
Subject: issue about virtio-net driver to suppoprt vhost mergeable buffer
 with zero-copy to support PS mode
Thread-Topic: issue about virtio-net driver to suppoprt vhost mergeable
 buffer with zero-copy to support PS mode
Thread-Index: Acr9Ot7nyMDBM1QRRSi0EsMAS1ZIoQ==
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D790B7958E740@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,
I'm now looking into the vhost mergeable buffer, and I tried to use it to support PS mode with zero-copy. And I found an issue there that I have to modify the guest virito-net driver.

When guest virtio-net driver submits mergeable buffers, it submits multiple pages outside. In zero-copy case, vhost cannot know which page is used to put header, and which page is used to put payload. Then vhost can only reserves 12 bytes for each page. That means, the page_offset of the payload DMAed into the guest buffer is always 12 bytes. But guest virtio-net driver always use offset 0 to put the data (See receive_mergeable()). That's where the zero-copy use mergeable buffer must modify.

Have I missed something here? And how do you think about it?

Thanks 
Xiaohui 
