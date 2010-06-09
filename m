Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0FIHgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:36:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:22234 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0FIHgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:36:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,389,1272870000"; 
   d="scan'208";a="286754692"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 9 Jun 2010 15:34:16 +0800
Subject: RE: [RFC PATCH v7 08/19] Make __alloc_skb() to get external buffer.
Thread-Topic: [RFC PATCH v7 08/19] Make __alloc_skb() to get external buffer.
Thread-Index: AcsEvvfRwC+bkk/FS1SoW7z09M2PswC5xHYg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D791100848EA7@shsmsx502.ccr.corp.intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-2-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-4-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-5-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-6-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-7-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-8-git-send-email-xiaohui.xin@intel.com>
 <1275749604.5238.239.camel@edumazet-laptop>
In-Reply-To: <1275749604.5238.239.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>Sent: Saturday, June 05, 2010 10:53 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mst@redhat.com; mingo@elte.hu; davem@davemloft.net; herbert@gondor.apana.org.au;
>jdike@linux.intel.com
>Subject: Re: [RFC PATCH v7 08/19] Make __alloc_skb() to get external buffer.
>
>Le samedi 05 juin 2010 à 18:14 +0800, xiaohui.xin@intel.com a écrit :
>> From: Xin Xiaohui <xiaohui.xin@intel.com>
>> 	child->fclone = SKB_FCLONE_UNAVAILABLE;
>>  	}
>> +	/* Record the external buffer info in this field. It's not so good,
>> +	 * but we cannot find another place easily.
>> +	 */
>> +	shinfo->destructor_arg = ext_page;
>> +
>
>
>Yes this is a big problem, its basically using a cache line that was not
>touched before.
>

Did your patch which moves destructor_arg before frags[] also fix this?

Thanks
Xiaohui
