Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2HOQqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:46:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40986 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755868Ab2HOQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:46:05 -0400
Date: Wed, 15 Aug 2012 17:45:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 04/31] arm64: MMU definitions
Message-ID: <20120815164529.GB14264@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
 <201208151330.02112.arnd@arndb.de>
 <CAMuHMdUEKNYFAU4N8KnJ0DPYgW7BRtaaJQSARDJCVjQOU2bFBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUEKNYFAU4N8KnJ0DPYgW7BRtaaJQSARDJCVjQOU2bFBw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 05:34:46PM +0100, Geert Uytterhoeven wrote:
> On Wed, Aug 15, 2012 at 3:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> +#define TCR_IPS_40BIT                (2 << 32)
> 
> By default, constants are int, i.e. 32-bit. So you must write
> 
> 2ULL << 32
> 
> >> +#define TCR_ASID16           (1 << 36)
> 
> 1ULL

Those higher constants are only used in assembly currently, so no
side-effects. But I agree that I should use something like:

	(_AC(1, UL) << 36)

(UL is sufficient on a 64-bit system)

Thanks.

-- 
Catalin
