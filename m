Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0FDAXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:23:11 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:62756 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0FDAXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:23:07 -0400
To: Russell King <rmk@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603164623.GM30622@atomide.com>
	<20100603181303.GB25779@flint.arm.linux.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 03 Jun 2010 17:23:04 -0700
In-Reply-To: <20100603181303.GB25779@flint.arm.linux.org.uk> (Russell King's message of "Thu\, 3 Jun 2010 19\:13\:03 +0100")
Message-ID: <8739x3ir2v.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk@arm.linux.org.uk> writes:

> On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
>> Compiling in multiple ARM platforms is trickier, we would have to get
>> rid of the duplicate defines like NR_IRQS, then have some common clock
>> framework etc. Then figure out some way to get rid of Makefile.boot.
>> Russell probably has some other things in mind that would have to be
>> changed to make this happen.
>
> - Find someway to handle the wide variety of interrupt controllers.
> - Be able to handle any multitude of V:P translations, including non-linear
>   alongside linear transations.
> - Different PAGE_OFFSETs
> - Different kernel VM layouts allowing for a variety of different ioremap
>   region sizes
>
> and so the list goes on...
>

- Support for ARMv5, v6 and v7 in the same kernel image.

On davinci, we've recently run into the problem where a new SoC in the
family is largely the same in terms of common HW blocks ands shared
peripherals with other davincis, but they upgraded from ARMv5 to
ARMv6.  Attempting to build a single kernel that supports ARMv5 and
ARMv6 uncovered a pile of assumptions that v5 and v6 would never be in
the same kernel.

Kevin
