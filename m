Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab0GUSFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:05:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9868 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761330Ab0GUSEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:04:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6050"; a="48187598"
Message-ID: <f63baf765051c19b85938ea73d6c6b2a.squirrel@www.codeaurora.org>
In-Reply-To: <20100721072837.GB6009@n2100.arm.linux.org.uk>
References: <20100714220536.GE18138@n2100.arm.linux.org.uk>
    <20100715012958.GB2239@codeaurora.org>
    <20100715085535.GC26212@n2100.arm.linux.org.uk>
    <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
    <20100716075856.GC16124@n2100.arm.linux.org.uk>
    <4C449183.20000@codeaurora.org>
    <20100719184002.GA21608@n2100.arm.linux.org.uk>
    <bb667e285fd8be82ea8cc9cc25cf335b.squirrel@www.codeaurora.org>
    <20100720222952.GD10553@n2100.arm.linux.org.uk>
    <EAF47CD23C76F840A9E7FCE10091EFAB02C61C5FCA@dbde02.ent.ti.com>
    <20100721072837.GB6009@n2100.arm.linux.org.uk>
Date: Wed, 21 Jul 2010 11:04:52 -0700 (PDT)
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU,
      CPU and device memory management
From: stepanm@codeaurora.org
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "Zach Pfeffer" <zpfeffer@codeaurora.org>,
        "Michael Bohan" <mbohan@codeaurora.org>, "Tim HRM" <zt.tmzt@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *************************************************************************
>> > This is difficult to achieve without remapping kernel memory using L2
>> > page tables, so we can unmap pages on 4K page granularity.  That's
>> > going to increase TLB overhead and result in lower system performance
>> > as there'll be a greater number of MMU misses.
> *************************************************************************

Given how the buffers in question can be on the orders of tens of MB (and
I don't think they will ever be less than 1MB), would we be able to get
the desired effect by unmapping and then remapping on a 1MB granularity
(ie, L1 sections)? It seems to me like this should be sufficient, and
would not require using L2 mappings. Thoughts?

Thanks
Steve

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.






