Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2HMCyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 22:54:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:64187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2HMCyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 22:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,757,1336374000"; 
   d="scan'208";a="179784587"
From: "Luck, Tony" <tony.luck@intel.com>
To: Hanjun Guo <guohanjun@huawei.com>, "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Jianguo Wu <wujianguo@huawei.com>
Subject: RE: [BUGFIX PATCH][RESEND] kexec & iosapic: kexec oops when iosapic
 was removed
Thread-Topic: [BUGFIX PATCH][RESEND] kexec & iosapic: kexec oops when
 iosapic was removed
Thread-Index: AQHNeP7pGYh1bPuB1UibjB7tcU+h4g==
Date: Mon, 13 Aug 2012 02:54:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19375F30@ORSMSX104.amr.corp.intel.com>
References: <1344583395-9128-1-git-send-email-guohanjun@huawei.com>
 <5025CD41.2030502@huawei.com>
In-Reply-To: <5025CD41.2030502@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>		vec = irq_to_vector(irq);
> 		list_for_each_entry(rte, &info->rtes,
> 				rte_list) {
> +			if (rte->refcnt == NO_REF_RTE)
> +				continue;
> +
> 			iosapic_write(rte->iosapic,
> 					IOSAPIC_RTE_LOW(rte->rte_index),
> 					IOSAPIC_MASK|vec);

This will work - but is it papering over a problem when you removed the
iosapic? Should we really have removed this "rte" from rte_list when the
iosapic was removed?

-Tony

.




