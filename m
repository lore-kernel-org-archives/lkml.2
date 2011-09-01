Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1IAJLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:11:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59663 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab1IAJL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:11:29 -0400
Date: Thu, 1 Sep 2011 10:11:11 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
Message-ID: <20110901091111.GB30417@e102144-lin.cambridge.arm.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314826214-22428-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Aug 31, 2011 at 10:30:11PM +0100, Mark Salter wrote:
> This patch set arose out of a discussion on linux-arm concerning a
> performance problem with USB on some ARMv7 based platforms. The
> problem was tracked down by ming.lei@canonical.com and found to be
> the result of CPU writes to DMA-coherent memory being delayed in a
> write buffer between the CPU and memory. One proposed patch fixed
> only the immediate problem with the USB EHCI driver, but several
> folks thought a more general approach was needed, so I put this series
> of patches together as a starting point for wider discussion outside
> the ARM specific list.

[...]

Whilst I'm in favour of this because it seems to be solving a real problem
(especially on OMAP4), I think we should get to the bottom of the issue
before augmenting the coherent DMA API. We currently have the following
unanswered questions:

(1) Why does a nosmp kernel not suffer from this problem?

(2) Why do *some* Tegra platforms seem to suffer whilst others do not?

(3) Can this problem be solved by configuring the hardware appropriately?

If (3) is true, then we might be better off solving it that way, although
I'd be interested to see if flushing CPU write buffers makes a difference to
I/O performance on other architectures using non-cacheable memory for
coherent DMA.

Will
