Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab1CaPYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:24:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab1CaPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:23:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Thu, 31 Mar 2011 17:23:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <201103301906.42429.arnd@arndb.de> <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6> <87d3l7jqpr.fsf@ti.com>
In-Reply-To: <87d3l7jqpr.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311723.02301.arnd@arndb.de>
X-Provags-ID: V02:K0:rG9T/DWqJO2ZsNoThzfls7wrAmYmqEJgta2iO83V9o3
 PTwcEl05RDlXeV5mvEHBxvbEcdu34V7YwP8Cdkmua26DpSTJVA
 T3SAG+0YLC+mEBppMpKhRSI0EhJp3XX6QsXePCy5YlQ0FQ/g+1
 UPM++y4rwYm64ZVaS68kG+/gnQy4kPIw1mMVBvzMo6DDf+UTHi
 sPkI5vDjQEZ/bu+LEBycw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Kevin Hilman wrote:
> Some SoCs families (like OMAP) have huge amount of diversity even within
> the SoC family, so better abstractions and generic infrastrucure
> improvements are an obvious win, even staying within the SoC.

But that's the point. The incentive is there for managing the infrastructure
within the SoC, but not across SoCs. Allow me to use OMAP as a bad example
while pointing out that it's really one of the best supported platforms
we currently have, while the others are usually much worse in terms of
working with the community (or at least they are behind on the learning
curve but getting there):

* OMAP2 introduced the hwmod concept as an attempt to reduce duplication
  between board code, but the code was done on the mach-omap2 level
  instead of finding a way to make it work across SOC vendors, or using
  an existing solution.

* The IOMMU code in omap2 duplicates the API we have in the common kernel,
  with slight differences, instead of using the existing code, making it
  impossible to share a driver between SOC families.

* The ti-st code duplicates parts of the bluetooth layer (apparently
  that is getting fixed soon).

* The DSS display drivers introduce new infrastructure include new bus
  types that have the complexity to make them completely generic, but
  in practice can only work on OMAP, and are clearly not written with
  cross-vendor abstractions in mind.

	Arnd
