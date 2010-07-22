Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0GVHgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:36:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40698 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0GVHgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:36:11 -0400
Date: Thu, 22 Jul 2010 08:34:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
Message-ID: <20100722073455.GB6802@n2100.arm.linux.org.uk>
References: <20100713150311B.fujita.tomonori@lab.ntt.co.jp> <20100713121420.GB4263@codeaurora.org> <20100714104353B.fujita.tomonori@lab.ntt.co.jp> <20100714201149.GA14008@codeaurora.org> <20100714220536.GE18138@n2100.arm.linux.org.uk> <20100715012958.GB2239@codeaurora.org> <20100715085535.GC26212@n2100.arm.linux.org.uk> <20100719065233.GD11054@codeaurora.org> <m1mxtndifi.fsf@fess.ebiederm.org> <20100722042528.GB22559@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722042528.GB22559@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 09:25:28PM -0700, Zach Pfeffer wrote:
> Yes it is a problem, as Russell has brought up, but there's something
> I probably haven't communicated well. I'll use the following example:
> 
> There are 3 devices: A CPU, a decoder and a video output device. All 3
> devices need to map the same 12 MB buffer at the same time.

Why do you need the same buffer mapped by the CPU?

Let's take your example of a video decoder and video output device.
Surely the CPU doesn't want to be writing to the same memory region
used for the output picture as the decoder is writing to.  So what's
the point of mapping that memory into the CPU's address space?

Surely the video output device doesn't need to see the input data to
the decoder either?

Surely, all you need is:

1. a mapping for the CPU for a chunk of memory to pass data to the
   decoder.
2. a mapping for the decoder to see the chunk of memory to receive data
   from the CPU.
3. a mapping for the decoder to see a chunk of memory used for the output
   video buffer.
4. a mapping for the output device to see the video buffer.

So I don't see why everything needs to be mapped by everything else.
