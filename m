Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0DFXX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:23:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39117 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab0DFXXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:23:19 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: <felipe.balbi@nokia.com>, "'ext Nishanth Menon'" <nm@ti.com>
Cc: <me@felipebalbi.com>, "'kishore kadiyala'" <kishorek.kadiyala@gmail.com>,
       "'Vimal Singh'" <vimal.newwork@gmail.com>, <tony@atomide.com>,
       "'S, Venkatraman'" <svenkatr@ti.com>, <linux-omap@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "'Lavinen Jarkko \(Nokia-D/Helsinki\)'" <jarkko.lavinen@nokia.com>
References: <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com> <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com> <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com> <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com> <20100405164839.GB17388@gandalf> <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com> <20100406050035.GA32537@gandalf> <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com> <20100406163211.GA29117@nokia.com> <4BBB6767.7010202@ti.com> <20100406165720.GA17916@nokia.com>
Subject: RE: [PATCH v3] OMAP: Fix for bus width which improves SD card's peformance.
Date: Tue, 6 Apr 2010 18:23:06 -0500
Message-ID: <00b401cad5e0$1d1868d0$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20100406165720.GA17916@nokia.com>
Thread-Index: AcrVqkkJRVtvtCiRSTeFvBHdLcv0dwANN0og
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
> Sent: Tuesday, April 06, 2010 11:57 AM
> To: ext Nishanth Menon
> Cc: Balbi Felipe (Nokia-D/Helsinki); Chikkature Rajashekar, Madhusudhan;
> me@felipebalbi.com; 'kishore kadiyala'; 'Vimal Singh'; tony@atomide.com;
> S, Venkatraman; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> Lavinen Jarkko (Nokia-D/Helsinki)
> Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
> peformance.
> 
> On Tue, Apr 06, 2010 at 06:55:03PM +0200, ext Nishanth Menon wrote:
> >some reasons why i love switch statements ;) since I dont expect other
> >than precisely 4 and 8 (do we expect 5,6,7 - i might be wrong).. but if
> >it is so, wont the following be better?
> >
> >switch (mmc_slot(host).wires)
> >{
> >case 8:
> >	mmc->caps |= MMC_CAP_8_BIT_DATA;
> >	/* fall thru*/
> >case 4:
> >	mmc->caps |= MMC_CAP_4_BIT_DATA;
> >		break;
> >default:
> >	WARN("bad width");
> >}
> 
> I like that, but I remember Madhu (or someone else) saying he thinks
> it's less readable this way. Go figure...
> 
Well, I did not comment on the usage of switch here. Note we only need to
handle 8-bit and 4-bit.The board files need not setup 8-bit or 4-bit if the
configuration of that board is 1-bit. The driver will still work in 1-bit
mode which would mean there is nothing to do in default case and should not
err out.

Regards,
Madhu

> --
> balbi

