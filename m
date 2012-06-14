Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2FNI4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:56:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:65460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2FNI4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:56:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157477088"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: xen/mce - mcelog at 100% cpu
Thread-Topic: xen/mce - mcelog at 100% cpu
Thread-Index: AQHNSZLddQXy2gd5YkW4phd9182UzZb5g2gw
Date: Thu, 14 Jun 2012 08:56:11 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233523183E@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
 <20120612124015.GB559@phenom.dumpdata.com>
 <20120613182458.GA5813@phenom.dumpdata.com>
In-Reply-To: <20120613182458.GA5813@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 12, 2012 at 08:40:15AM -0400, Konrad Rzeszutek Wilk wrote:
>> On Tue, Jun 12, 2012 at 07:51:03AM +0000, Liu, Jinsong wrote:
>>>> From aa2ce7440f16002266dc8464f749992d0c8ac0e5 Mon Sep 17 00:00:00
>>>> 2001 
>>> From: Liu, Jinsong <jinsong.liu@intel.com>
>>> Date: Tue, 12 Jun 2012 23:11:16 +0800
>>> Subject: [PATCH] xen/mce: schedule a workqueue to avoid sleep in
>>> atomic context 
>>> 
>>> copy_to_user might sleep and print a stack trace if it is executed
>>> in an atomic spinlock context.
>>> 
>>> This patch schedule a workqueue for IRQ handler to poll the data,
>>> and use mutex instead of spinlock, so copy_to_user sleep in atomic
>>> context would not occur.
>> 
>> Ah much better. Usually one also includes the report of what the
>> stack trace was. So I've added that in.
> 
> So another bug which is that mcelog is spinning at 100% CPU (and only
> under Xen).
> 
> It seems to be doing:
> 
> ppoll([{fd=4, events=POLLIN}, {fd=3, events=POLLIN}], 2, NULL, [], 8)
> = 1 ([{fd=3, revents=POLLIN}]) read(3, "", 2816)                     
> = 0 
> ppoll([{fd=4, events=POLLIN}, {fd=3, events=POLLIN}], 2, NULL, [], 8)
> = 1 ([{fd=3, revents=POLLIN}]) read(3, "", 2816)
> 
> constantly.

I will debug it. I have try at my platform, but fail to reproduce it. (You still use the config you send me last time, right?)
Would you tell me your step?

Thanks,
Jinsong