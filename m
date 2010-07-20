Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825Ab0GTWCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:02:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25876 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761779Ab0GTWCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:02:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6049"; a="48091429"
Message-ID: <bb667e285fd8be82ea8cc9cc25cf335b.squirrel@www.codeaurora.org>
In-Reply-To: <20100719184002.GA21608@n2100.arm.linux.org.uk>
References: <20100713150311B.fujita.tomonori@lab.ntt.co.jp>
    <20100713121420.GB4263@codeaurora.org>
    <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
    <20100714201149.GA14008@codeaurora.org>
    <20100714220536.GE18138@n2100.arm.linux.org.uk>
    <20100715012958.GB2239@codeaurora.org>
    <20100715085535.GC26212@n2100.arm.linux.org.uk>
    <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
    <20100716075856.GC16124@n2100.arm.linux.org.uk>
    <4C449183.20000@codeaurora.org>
    <20100719184002.GA21608@n2100.arm.linux.org.uk>
Date: Tue, 20 Jul 2010 15:02:34 -0700 (PDT)
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU,
      CPU and device memory management
From: stepanm@codeaurora.org
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Michael Bohan" <mbohan@codeaurora.org>, "Tim HRM" <zt.tmzt@gmail.com>,
        "Zach Pfeffer" <zpfeffer@codeaurora.org>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell-

If a driver wants to allow a device to access memory (and cache coherency
is off/not present for device addesses), the driver needs to remap that
memory as non-cacheable. Suppose there exists a chunk of
physically-contiguous memory (say, memory reserved for device use) that
happened to be already mapped into the kernel as normal memory (cacheable,
etc). One way to remap this memory is to use ioremap (and then never touch
the original virtual mapping, which would now have conflicting
attributes). I feel as if there should be a better way to remap memory for
device access, either by altering the attributes on the original mapping,
or removing the original mapping and creating a new one with attributes
set to non-cacheable. Is there a better way to do this than calling
ioremap() on that memory? Please advise.

Thanks
Steve


Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


> On Mon, Jul 19, 2010 at 10:55:15AM -0700, Michael Bohan wrote:
>>
>> On 7/16/2010 12:58 AM, Russell King - ARM Linux wrote:
>>
>>> As the patch has been out for RFC since early April on the
>>> linux-arm-kernel
>>> mailing list (Subject: [RFC] Prohibit ioremap() on kernel managed RAM),
>>> and no comments have come back from Qualcomm folk.
>>
>> Would it be unreasonable to allow a map request to succeed if the
>> requested attributes matched that of the preexisting mapping?
>
> What would be the point of creating such a mapping?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>






