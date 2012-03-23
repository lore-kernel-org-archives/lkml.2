Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2CWRiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:38:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab2CWRiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:38:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 7/9] omap2plus: ensure that one of omap2/3/4 is selected
Date: Fri, 23 Mar 2012 17:38:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: mathieu.poirier@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org> <1332522836-29517-8-git-send-email-mathieu.poirier@linaro.org> <20120323172845.GC9859@atomide.com>
In-Reply-To: <20120323172845.GC9859@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203231738.05742.arnd@arndb.de>
X-Provags-ID: V02:K0:53iC14r9OUBaZiaYzy8LTtZPoF17LcxYOQEfdAoAk9j
 +Uz/uOQPX6I7GrjJn8IcvvTSmgxkm1xT/WLhC1845ySG/GV53p
 SUZ703tCFTr9Gp5tfQCirunRqOaLWmqaxfJIW6G/KtmI1HZDpb
 gFyg2AKHLZfLtBjaVAwbhGVmVrS62mwYUNH7VCi065wFbfNjjL
 1EvorqGSKAD1YIMFs/0UbeSmBLeIyHI+jzJwJkiinP96hnocqt
 +8aKGCDRhegDkGa4Ai3SHPWjta05QGRsfK0noa5K76CM9wRYmh
 nnjSBK3VpmsI2BD8TSSemBK2m/4pK5dbcUmJp1P8U+L6A/68if
 xvNCt9NYuwD3z6qoNX2Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2012, Tony Lindgren wrote:
> >  
> > +config ARCH_OMAP2_AUTO
> > +     bool
> > +     depends on !ARCH_OMAP3 && !ARCH_OMAP4
> > +     select ARCH_OMAP2
> > +     default y
> > +     help
> > +       At least one of OMAP2/OMAP3/OMAP4 needs to be enabled, this
> > +       selects OMAP2 if nothing else gets selected, to avoid non-building
> > +       configurations.
> > +
> >  comment "OMAP Core Type"
> >       depends on ARCH_OMAP2
> 
> Hmm yeah omap2 makes the smallest build, so randconfig builds
> faster than it would for omap3 or 4.
> 
> But isn't there now still a chance that randconfig does not
> select ARCH_OMAP2_AUTO either?

No. ARCH_OMAP2_AUTO is only disabled if one of OMAP3 or OMAP4
are enabled.

	Arnd
