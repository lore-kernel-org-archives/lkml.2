Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1A1WSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:18:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12481 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1A1WSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:18:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Fri, 28 Jan 2011 14:18:06 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Fri, 28 Jan 2011 14:18:01 -0800
Subject: RE: [PATCH v1] input: tegra-kbc: Fix build error.
Thread-Topic: [PATCH v1] input: tegra-kbc: Fix build error.
Thread-Index: Acu/OCXpnmaX1JGZTlqT6J4uAIhG+AAANdXg
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A0080A0@HQMAIL03.nvidia.com>
References: <1296252213-15003-1-git-send-email-riyer@nvidia.com>
 <20110128220952.GK6252@core.coreip.homeip.net>
In-Reply-To: <20110128220952.GK6252@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No I think this slipped in, due to a last minute change to get the code < 80 lines.

Regards
Rakesh

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Friday, January 28, 2011 2:10 PM
> To: Rakesh Iyer
> Cc: olof@lixom.net; Andrew Chew; linux-tegra@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH v1] input: tegra-kbc: Fix build error.
> 
> On Fri, Jan 28, 2011 at 02:03:33PM -0800, riyer@nvidia.com wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> >
> > Fix build error introduced by variable name change.
> >
> 
> Did I manage to pick up wrong version?
> 
> > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > ---
> >  drivers/input/keyboard/tegra-kbc.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> > index 6ca903a..ac471b7 100644
> > --- a/drivers/input/keyboard/tegra-kbc.c
> > +++ b/drivers/input/keyboard/tegra-kbc.c
> > @@ -355,8 +355,8 @@ static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
> >  	for (i = 0; i < KBC_MAX_GPIO; i++) {
> >  		u32 r_shft = 5 * (i % 6);
> >  		u32 c_shft = 4 * (i % 8);
> > -		u32 r_mask = 0x1f << r_shift;
> > -		u32 c_mask = 0x0f << c_shift;
> > +		u32 r_mask = 0x1f << r_shft;
> > +		u32 c_mask = 0x0f << c_shft;
> >  		u32 r_offs = (i / 6) * 4 + KBC_ROW_CFG0_0;
> >  		u32 c_offs = (i / 8) * 4 + KBC_COL_CFG0_0;
> >  		u32 row_cfg = readl(kbc->mmio + r_offs);
> > --
> > 1.7.0.4
> >
> 
> --
> Dmitry
