Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2BQJE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:04:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12167 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2BQJE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:04:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 17 Feb 2012 01:04:17 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 17 Feb 2012 14:34:13 +0530
Subject: RE: [PATCH] mm: mmap() sometimes succeeds even if the region to map
 is invalid.
Thread-Topic: [PATCH] mm: mmap() sometimes succeeds even if the region to
 map is invalid.
Thread-Index: AcztUDi6hYecutHrRdSrHR3aBZgXpAAAflEA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD198A7AE@BGMAIL02.nvidia.com>
References: <4F3E1319.6050304@jp.fujitsu.com>
In-Reply-To: <4F3E1319.6050304@jp.fujitsu.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The detail of these problems is as follows:

> 1. mmap() succeeds even if "offset" argument is a negative value, although
>    it should return EINVAL in such case.

> In such case, it is actually regarded as big positive value
> because the type of "off" is "unsigned long" in the kernel.
> For example, off=-4096 (-0x1000) is regarded as
> off = 0xfffffffffffff000 (x86_64) and as off = 0xfffff000 (x86).
> It results in mapping too big offset region.

It is not true always.

Considering your example, say if page size is 4k, then PAGE_MASK = 0xFFF
hence (off & ~PAGE_MASK) will be true and " -EINVAL" will be returned.
