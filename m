Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0EEFVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:21:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:19521 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab0EEFVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:21:14 -0400
Subject: Re: [PATCH] ubi: init even if mtd device cannot be attached, if
 built into kernel
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Kevin Cernekee <kpc.mtd@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>,
       Roel Kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1273036359.3702.35.camel@localhost>
References: <1272537664-21603-1-git-send-email-mkl@pengutronix.de>
	 <1273036359.3702.35.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 08:14:42 +0300
Message-ID: <1273036482.3702.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 05:20:54.0896 (UTC) FILETIME=[BC76F700:01CAEC12]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 08:12 +0300, Artem Bityutskiy wrote:
> > +#ifdef CONFIG_MTD_UBI_MODULE
> > +static inline int ubi_is_module(void) { return 1; }
> > +#else
> > +static inline int ubi_is_module(void) { return 0; }
> > +#endif
> 
> I really hate these ifdefs. Dunno why, but they feel disgusting.
> 
> I understand your issue and agree that is should be fixed. And I cannot
> really see a better solution. So if no-one complains, I'll accept your
> patch.
> 
> However, for consistency with other UBI code (see debug.h), please, do
> this like
> 
> #ifdef CONFIG_MTD_UBI_MODULE
> #define ubi_is_module() 1
> #else
> #define ubi_is_module() 1
> #endif

Err, of course the second one should be 0, not 1. I can actually do this
modification myself, or you can re-send your patch.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

