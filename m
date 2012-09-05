Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab2IEVFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:05:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54472 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2IEVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:05:45 -0400
Date: Wed, 5 Sep 2012 22:05:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 20/31] arm64: User access library function
Message-ID: <20120905210534.GI24085@n2100.arm.linux.org.uk>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-21-git-send-email-catalin.marinas@arm.com> <201208151449.54834.arnd@arndb.de> <20120905191312.GH24085@n2100.arm.linux.org.uk> <20120905210135.GA87548@MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905210135.GA87548@MacBook-Pro.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:01:37PM +0100, Catalin Marinas wrote:
> There are indeed a few KB gain in code size but that's probably coming
> from the exception table since otherwise you just replace a bl with
> ldrt. It depends on what the compiler does as well, the arm code has
> some carefully chosen registers when calling the __get_user_x function.

It's more than that - it's not just the ldr but also a zeroing of a
temporary register to hold the error code should the instruction fault.
So it's not only the exception tables but also an increase in the
main path - and that's where you benefit from having it out of line and
thereby a hotter i-cache.

> If you do the access_ok inline and the __get_user_x separately, the size
> increase is even greater (at least in the arm64 case it can get to over
> 20KB). I think x86 does the access_ok check out of line.

Please talk to Will about get_user() and put_user().  Afterwards you
will definitely want to keep them out of line on 64-bit ARM.
