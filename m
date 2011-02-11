Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1BKJkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:40:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50378 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab1BKJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:40:04 -0500
Date: Fri, 11 Feb 2011 09:38:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sachin Verma <imschnvrm@gmail.com>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        catalin.marinas@arm.com
Subject: Re: ARM: relocation out of range (when loading a module)
Message-ID: <20110211093853.GA23404@n2100.arm.linux.org.uk>
References: <4D2D1942.4050905@ahsoftware.de> <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com> <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1101121350350.25498@xanadu.home> <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com> <alpine.LFD.2.00.1101270030220.8580@xanadu.home> <20110210154322.GE1742@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1102101405010.14920@xanadu.home> <AANLkTi=KtFf5BU-iH-sUUL=Q30S90bk608JR4zFz2CKf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=KtFf5BU-iH-sUUL=Q30S90bk608JR4zFz2CKf@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 09:31:04AM +0000, Dave Martin wrote:
> You could probably cook up a good upper bound based on the size of the
> kernel and the number of symbols in the module: i.e., assume that
> every undefined symbol in the module needs to be fixed up to point at
> the most distant symbol in the kernel.
> 
> For people with normal-sized kernels, this bound will probably work
> out as zero most of the time (i.e., the current situation).  For
> people with big kernels, or when many modules are already loaded, it
> may work out at 100% -- but that's the price to pay for guaranteed
> preallocation of the space required for the veneers.  And anyway, you
> may really need a substantial chunk of those veneers in such cases.

I think it's going to be easier just to re-order the kernel image link
order to solve that problem.  That just leaves uclinux...
