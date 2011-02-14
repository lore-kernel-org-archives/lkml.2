Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab1BNPk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:40:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1BNPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:40:54 -0500
Date: Mon, 14 Feb 2011 15:40:12 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: ShiYong LI <a22381@motorola.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
Message-ID: <20110214154011.GA1595@flint.arm.linux.org.uk>
References: <20110207180606.GB2966@flint.arm.linux.org.uk> <AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com> <20110208125546.GA4286@flint.arm.linux.org.uk> <alpine.DEB.2.00.1102080856020.12521@router.home> <AANLkTimFDZFcO=J6PEOOo5RBdr0m7fjCKzWh1M_NaiLx@mail.gmail.com> <20110211091413.GA32687@flint.arm.linux.org.uk> <alpine.DEB.2.00.1102110920060.12360@router.home> <20110211153524.GB26188@flint.arm.linux.org.uk> <AANLkTimDUf52xdHn22=f1J=Xn88sqPEg9P6+ceas1h1k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimDUf52xdHn22=f1J=Xn88sqPEg9P6+ceas1h1k@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:10:45AM +0800, ShiYong LI wrote:
> Hi all,
> 
> Sorry for my late reply.
> 
> My commit is created to enable ARM with 128 byte cache line support last
> information dump while slab corruption occurs. I've verified it works fine
> on ARMv7.

Mainline only supports 32 byte and 64 byte cache lines on ARM.  It does
not support 128 byte cache lines, so maybe your attempts are the wrong
approach.  Can you please post your 128 byte cache line support patches
to the ARM kernel mailing list for review.

In the mean time, because your patch causes an oopsing regression, I
strongly suggest that it is reverted until we start supporting 128 byte
cache lines on ARM in mainline.

> Russell,
> 
> Can you provide more information for the problem? What kind of ARM are you
> using ?

ARM926, which has a cache line size of 32.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
