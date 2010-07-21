Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab0GUFTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:19:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762570Ab0GUFS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:18:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6049"; a="48126046"
Message-ID: <5a63b73ff04b72db2930eae4e43e5c5b.squirrel@www.codeaurora.org>
Date: Tue, 20 Jul 2010 22:18:55 -0700 (PDT)
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU,
           CPU and device memory management
From: stepanm@codeaurora.org
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: zpfeffer@codeaurora.org, linux@arm.linux.org.uk,
        fujita.tomonori@lab.ntt.co.jp, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the problem about mapping a 1MB buffer with the DMA API?
>
> Possibly, an IOMMU can't find space for 1MB but it's not the problem of
the DMA API.

As you have pointed out, one of the issues is that allocation can fail.
While technically VCMM allocations can fail as well, these allocations can
be made from one or more memory pools that have been set aside
specifically to be used by devices. Thus, the kernel's normal allocator
will not encroach on the large physically-contiguous chunks (of size 1MB
or even 16MB) that are not easy to get back, and would be forced to deal
with increasing memory pressure in other ways.
Additionally, some of the memory pools may have special properties, such
as being part of on-chip memory with higher performance than regular
memory, and some devices may have special requirements regarding what type
or memory they need. The VCMM allocator solves the problem in a generic
way by being able to deal with multiple memory pools and supporting
prioritization schemes for which subset of the memory pools is to be used
for each physical allocation.

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




