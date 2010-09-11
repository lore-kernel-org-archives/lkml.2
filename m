Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0IKJmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:42:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:48888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0IKJmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,351,1280732400"; 
   d="scan'208";a="553563804"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Sat, 11 Sep 2010 17:42:30 +0800
Subject: RE: [RFC PATCH v9 12/16] Add mp(mediate passthru) device.
Thread-Topic: [RFC PATCH v9 12/16] Add mp(mediate passthru) device.
Thread-Index: ActNtR+uQvbWPZRgSsWQthsUVTZ+wwDKrubAAC1OA1A=
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D79280489AA0C@shsmsx502.ccr.corp.intel.com>
References: <1281086624-5765-5-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-6-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-7-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-8-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-9-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-10-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-11-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-12-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-13-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-14-git-send-email-xiaohui.xin@intel.com>
 <20100906111126.GA15608@redhat.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79280489A9C9@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D79280489A9C9@shsmsx502.ccr.corp.intel.com>
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

>>> +
>>> +	if (ctor->lock_pages + count > lock_limit && npages) {
>>> +		printk(KERN_INFO "exceed the locked memory rlimit.");
>>> +		return NULL;
>>> +	}
>>> +
>>> +	info = kmem_cache_zalloc(ext_page_info_cache, GFP_KERNEL);
>>
>>You seem to fill in all memory, why zalloc? this is data path ...
>
>Ok, Let me check this.

It's mainly for info->next and info->prev, these two fields will be used in hash functions.
But you are right, since most fields will be refilled. The new version includes the fix. 

Thanks
Xiaohui
