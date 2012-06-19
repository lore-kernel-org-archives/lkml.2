Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2FSIut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:50:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8764 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2FSIur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:50:47 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-67-4fe03d66a1bd
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>
Cc: "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
References: <1335090082.1814.27.camel@x61.thuisdomein>
 <4F973FB2.1050004@samsung.com> <1339322235.30984.35.camel@x61.thuisdomein>
In-reply-to: <1339322235.30984.35.camel@x61.thuisdomein>
Subject: RE: arch/arm/mach-s3c2410/Kconfig is unsourced
Date: Tue, 19 Jun 2012 17:50:45 +0900
Message-id: <019b01cd4df8$9dbc8ba0$d935a2e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1G72ua99LsFSAqRgWeje6t84NhvgHB1MNw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd002wf+BoeWSVhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs6d7KWLBWoGLBl2msDYxtvF2MHBwSAiYSE6fJdjFy
	ApliEhfurWfrYuTiEBJYxCjRfn8RI4Tzl1Fi1vprjCBVbAIaEoffP2MHsUUEVCU2fv7ADFLE
	LLCPUeLSq82sEB3NjBJdj64zg1RxClhIrOh+zQpiCwuYSzzs7WADsVmAuhvfvGUBsXkFbCV2
	NF1ihbAFJX5MvgcWZxZQl5g0bxEzhK0t8eTdBVaIs9UlHv3VhTjCSOL0i3usECUiEvtevGOc
	wCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoP6mdQOxpUN
	FocYBTgYlXh4D8o98BdiTSwrrsw9xCjBwawkwrvq/31/Id6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rxN1hf8hQTSE0tSs1NTC1KLYLJMHJxSDYzKC0pCmJ7LR+Qd1NjIub9b+qtEQstOm/QFTsZH
	DQL5pnvF28n2NS9bUJpn1uDqsfiSyQuV+/JHTl9j75vHaVOysWeb9pLgCfMvv/x51qGcoT9o
	xiM/rpbgdv6Jm6PZ71k6LvWp/jppCleW7T+z0CXuJwP4c+1+8ChYPXZI28Vuu3EqT+isx0os
	xRmJhlrMRcWJAJiAOdpmAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> On Tue, 2012-04-24 at 17:05 -0700, Kukjin Kim wrote:
> > Paul Bolle wrote:
> > > 0) commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410:
> move
> > > mach-s3c2410/* into mach-s3c24xx/") orphaned
> > > arch/arm/mach-s3c2410/Kconfig: currently nothing sources that file in
> > > Linus' tree.
> > >
> > Oops, you're right.
> >
> > > 1) I haven't looked in depth at this, but this made S3C2410_PLLTABLE
> > > disappear from the build system (ie, arch/arm/mach-s3c2410/pll.c is
> dead
> > > code now). Moreover, this basically turned both "select
> S3C2410_CPUFREQ
> > > if CPU_FREQ_S3C24XX", under "config CPU_S3C2410", and "select
> > > S3C2410_IOTIMING if S3C2410_CPUFREQ", under "config ARCH_BAST", into
> > > nops (both in arch/arm/mach-s3c24xx/Kconfig).
> > >
> > > 2) So to me it seems the move has only been done half: either more
> > > things needs to be moved or those things can be removed entirely. But
> > > perhaps arch/arm/mach-s3c2410/Kconfig should just be sourced again.
> > >
> > Yes, I think, would be better right now, if we could add just sourcing
> > mach-s3c2410/Kconfig but as you said, I need to remove entire mach-s3c24
> > stuff.
> >
> > Thanks for your pointing out and let me fix it.
> 
> I reported this issue just after v3.4-rc4 was released. We're now at
> v3.5-rc2 and arch/arm/mach-s3c2410/Kconfig is still unsourced. I'm
> tempted to submit a clean up patch (though I haven't checked what
> currently can be removed because that Kconfig file is still unsourced).
> But perhaps there's a fix pending in some development branch.
> 
Yeah, I'm working on moving s3c24xx cpufreq into drivers/cpufreq/ and then the arch/arm/mach-s3c2410/ will be removed. But I lost the chance in the last time :( and this will be cleared from v3.6 with my patch.

So I think, your cleanup patch would be nice now.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

