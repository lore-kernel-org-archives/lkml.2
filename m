Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab0GMFVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:21:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0GMFVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:21:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6041"; a="47295344"
Message-ID: <4C3BF7C1.9040904@codeaurora.org>
Date: Mon, 12 Jul 2010 22:21:05 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Hari Kanigeri <hari.kanigeri@gmail.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <AANLkTinABCSdN6hnXVOvVZ12f1QBMR_UAi62qW8GmlkL@mail.gmail.com> <4C2D908E.9030309@codeaurora.org> <20100710143635.GA10080@8bytes.org>
In-Reply-To: <20100710143635.GA10080@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Fri, Jul 02, 2010 at 12:09:02AM -0700, Zach Pfeffer wrote:
>> Hari Kanigeri wrote:
>>>> He demonstrated the usage of his code in one of the emails he sent out
>>>> initially. Did you go over that, and what (or how many) step would you
>>>> use with the current code to do the same thing?
>>> -- So is this patch set adding layers and abstractions to help the User ?
>>>
>>> If the idea is to share some memory across multiple devices, I guess
>>> you can achieve the same by calling the map function provided by iommu
>>> module and sharing the mapped address to the 10's or 100's of devices
>>> to access the buffers. You would only need a dedicated virtual pool
>>> per IOMMU device to manage its virtual memory allocations.
>> Yeah, you can do that. My idea is to get away from explicit addressing
>> and encapsulate the "device address to physical address" link into a
>> mapping.
> 
> The DMA-API already does this with the help of IOMMUs if they are
> present. What is the benefit of your approach over that?

The grist to the DMA-API mill is the opaque scatterlist. Each
scatterlist element brings together a physical address and a bus
address that may be different. The set of scatterlist elements
constitute both the set of physical buffers and the mappings to those
buffers. My approach separates these two things into a struct physmem
which contains the set of physical buffers and a struct reservation
which contains the set of bus addresses (or device addresses). Each
element in the struct physmem may be of various lengths (without
resorting to chaining). A map call maps the one set to the other. 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
