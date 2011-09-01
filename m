Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab1IASIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 14:08:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34964 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab1IASIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 14:08:18 -0400
Date: Thu, 1 Sep 2011 19:07:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <ming.lei@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
Message-ID: <20110901180753.GB15814@n2100.arm.linux.org.uk>
References: <CACVXFVOT9FZexiZhuJtvyFP8qOPYUKg0JqGarBJgT4R8SN7p5Q@mail.gmail.com> <Pine.LNX.4.44L0.1109011127080.1896-100000@iolanthe.rowland.org> <20110901160429.GA15814@n2100.arm.linux.org.uk> <20110901173149.GE2803@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901173149.GE2803@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 06:31:49PM +0100, Will Deacon wrote:
> Given that I believe our coherent DMA memory is `cacheable, bufferable, do
> not allocate' in terms of AXI attributes, then writes will go straight to
> the write buffer on the PL310.

It's TEXCB=001, which due to the PRRR and NMRR registers is memory type
10, inner policy 00 outer policy 00, which translated means (as I said)
"Normal memory", "non-cacheable" at both the inner and outer levels.

How that gets translated to AXI attributes is outside the scope of the
ARM ARM, it's probably in some mega secret AXI document somewhere which
I don't have access to.
