Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1IATOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab1IATOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:14:36 -0400
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
From: Mark Salter <msalter@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 01 Sep 2011 15:14:18 -0400
In-Reply-To: <20110901173149.GE2803@e102144-lin.cambridge.arm.com>
References: <CACVXFVOT9FZexiZhuJtvyFP8qOPYUKg0JqGarBJgT4R8SN7p5Q@mail.gmail.com>
	 <Pine.LNX.4.44L0.1109011127080.1896-100000@iolanthe.rowland.org>
	 <20110901160429.GA15814@n2100.arm.linux.org.uk>
	 <20110901173149.GE2803@e102144-lin.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1314904459.1439.24.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 18:31 +0100, Will Deacon wrote:
> I don't think what we're seeing in this case is caused by mismatched memory
> attributes, especially as passing `nosmp' on the command-line makes the
> performance issue disappear.

I'm coming to think we are dealing with two different problems.

We have the original problem where adding the write buffer flush
to EHCI gives a 4x performance boost to USB. Also adding nosmp to
the cmdline gives pretty much the same boost. This is looking like
something other than just data getting held up in a write buffer.

On the other hand, on a nosmp kernel, I get about 3-4% performance
boost for hdparm -t using the write buffer flush patch vs. without
it.

So, regardless of what turns out to be the actual cause of the 4x
problem, it may still be worthwhile to have the explicit write
buffer sync API if we can't avoid using buffered mappings for DMA.

--Mark


