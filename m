Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2IFIhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:37:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45699 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657Ab2IFIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:36:58 -0400
Date: Thu, 6 Sep 2012 09:36:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 20/31] arm64: User access library function
Message-ID: <20120906083607.GA13975@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-21-git-send-email-catalin.marinas@arm.com>
 <201208151449.54834.arnd@arndb.de>
 <20120905191312.GH24085@n2100.arm.linux.org.uk>
 <20120905210135.GA87548@MacBook-Pro.local>
 <20120905210534.GI24085@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905210534.GI24085@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:05:34PM +0100, Russell King - ARM Linux wrote:
> On Wed, Sep 05, 2012 at 10:01:37PM +0100, Catalin Marinas wrote:
> > There are indeed a few KB gain in code size but that's probably coming
> > from the exception table since otherwise you just replace a bl with
> > ldrt. It depends on what the compiler does as well, the arm code has
> > some carefully chosen registers when calling the __get_user_x function.
> 
> It's more than that - it's not just the ldr but also a zeroing of a
> temporary register to hold the error code should the instruction fault.
> So it's not only the exception tables but also an increase in the
> main path - and that's where you benefit from having it out of line and
> thereby a hotter i-cache.

On 32-bit we have __get_user() inline and get_user() out of line. What
was the history behind this?

> > If you do the access_ok inline and the __get_user_x separately, the size
> > increase is even greater (at least in the arm64 case it can get to over
> > 20KB). I think x86 does the access_ok check out of line.
> 
> Please talk to Will about get_user() and put_user().  Afterwards you
> will definitely want to keep them out of line on 64-bit ARM.

As I said, I already made the change to always inline get_user/put_user
with some penalty in the Image size but it makes the code cleaner. I'm
not entirely convinced of the performance gain/loss especially on ARMv8
cores with physically tagged caches. There is room for optimisation when
I get real silicon.

-- 
Catalin
