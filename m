Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab0ENXxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:53:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38689 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab0ENXxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:53:15 -0400
Message-ID: <4BEDE1EA.8030103@oracle.com>
Date: Fri, 14 May 2010 16:51:06 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: lmb type features.
References: <1273804238.21352.389.camel@pasglop>	 <4BECF00D.6080800@oracle.com>	<1273825187.21352.590.camel@pasglop>	 <20100514.013012.13730149.davem@davemloft.net>	 <4BED7DFE.2090108@oracle.com> <1273876488.21352.643.camel@pasglop>
In-Reply-To: <1273876488.21352.643.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BEDE255.0104:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

like you to make some change to lmb_type and double_array()

struct lmb_type {
        unsigned long cnt;      /* number of regions */
        unsigned long max;      /* size of the allocated array */
        struct lmb_region *regions;
};

==>

struct lmb_type {
        unsigned long cnt;      /* number of regions */
        unsigned long max;      /* size of the allocated array */
	unsigned long features;
        struct lmb_region *regions;
};


then have 

#define LMB_ADD_MERGE (1<<0) 
#define LMB_ARRAY_DOUBLE (1<<1)

so before call double_lmb_array(), should check the features to bit is set or not.
otherwise should emit PANIC with clear message.

Usage:

for range replacement,

1. early stage before lmb.reserved, lmb.memory is there.
so can not use lmb_find_base yet.

2. for bootmem replacement, when do range set subtraction for final free range list,
don't want to change lmb.reserved in the middle.  callee should make sure to have big
enough temperately lmb_regions in lmb_type. 

Thanks

Yinghai

