Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0GCGgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 02:36:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0GCGg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 02:36:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6031"; a="46217836"
Message-ID: <4C2EDA6C.7030405@codeaurora.org>
Date: Fri, 02 Jul 2010 23:36:28 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Daniel Walker <dwalker@codeaurora.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@jasper.es
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <1278012503.7738.17.camel@c-dwalke-linux.qualc <20100701230056.GD3594@basil.fritz.box>
In-Reply-To: <20100701230056.GD3594@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The standard Linux approach to such a problem is to write
> a library that drivers can use for common functionality, not put a middle 
> layer inbetween. Libraries are much more flexible than layers.

I've been thinking about this statement. Its very true. I use the
genalloc lib which is a great piece of software to manage VCMs
(domains in linux/iommu.h parlance?).

On our hardware we have 3 things we have to do, use the minimum set of
mappings to map a buffer because of the extremely small TLBs in all the
IOMMUs we have to support, use special virtual alignments and direct
various multimedia flows through certain IOMMUs. To support this we:

1. Use the genalloc lib to allocate virtual space for our IOMMUs,
allowing virtual alignment to be specified.

2. Have a maxmunch allocator that manages our own physical pool.

I think I may be able to support this using the iommu interface and
some util functions. The big thing that's lost is the unified topology
management, but as demonstrated that may fall out from a refactor.

Anyhow, sounds like a few things to try. Thanks for the feedback so
far. I'll do some refactoring and see what's missing.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
