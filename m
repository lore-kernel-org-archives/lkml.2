Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0JKHGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:06:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:15273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab0JKHGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:06:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,312,1283756400"; 
   d="scan'208";a="615422835"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Mon, 11 Oct 2010 15:06:05 +0800
Subject: RE: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
Thread-Topic: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
Thread-Index: ActhOEVZffHOl0D1SHqNcCjYCrmPKgH2ZYSg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D793064B2A9D8@shsmsx502.ccr.corp.intel.com>
References: <1285855474-12110-1-git-send-email-xiaohui.xin@intel.com>
	<59d8a50047ee01e26658fd676d26c0162b79e5fd.1285853725.git.xiaohui.xin@intel.com>
	<f2bf65a8a7676bbd3e8a749ae93d99e88671d35d.1285853725.git.xiaohui.xin@intel.com>
 <20101001.001439.85411154.davem@davemloft.net>
In-Reply-To: <20101001.001439.85411154.davem@davemloft.net>
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

>-----Original Message-----
>From: David Miller [mailto:davem@davemloft.net]
>Sent: Friday, October 01, 2010 3:15 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mst@redhat.com; mingo@elte.hu; herbert@gondor.apana.org.au; jdike@linux.intel.com
>Subject: Re: [PATCH v12 06/17] Use callback to deal with skb_release_data() specially.
>
>From: xiaohui.xin@intel.com
>Date: Thu, 30 Sep 2010 22:04:23 +0800
>
>> @@ -197,10 +197,11 @@ struct skb_shared_info {
>>  	union skb_shared_tx tx_flags;
>>  	struct sk_buff	*frag_list;
>>  	struct skb_shared_hwtstamps hwtstamps;
>> -	skb_frag_t	frags[MAX_SKB_FRAGS];
>>  	/* Intermediate layers must ensure that destructor_arg
>>  	 * remains valid until skb destructor */
>>  	void *		destructor_arg;
>> +
>> +	skb_frag_t	frags[MAX_SKB_FRAGS];
>>  };
>>
>>  /* The structure is for a skb which pages may point to
>
>Why are you moving frags[] to the end like this?

That's to avoid the new cache miss caused by using destructor_arg in data path
like skb_release_data().
That's based on the comment from Eric Dumazet on v7 patches.

Thanks
Xiaohui
