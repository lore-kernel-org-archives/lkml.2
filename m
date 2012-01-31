Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2AaT3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:29:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14695 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2AaT3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:29:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 31 Jan 2012 11:29:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Shridhar Rasal <srasal@nvidia.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 31 Jan 2012 11:29:35 -0800
Subject: RE: [PATCH 1/1] input: keyboard: Set configuration registers
Thread-Topic: [PATCH 1/1] input: keyboard: Set configuration registers
Thread-Index: AczgS9JRSALp8/DPRSWdOYXBpvaSTwAApdww
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E1244A2@HQMAIL01.nvidia.com>
References: <1323415758-16822-1-git-send-email-srasal@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1751860550@HQMAIL01.nvidia.com>
 <3849551.l2KNPKMSmh@dtor-d630.eng.vmware.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17518605E5@HQMAIL01.nvidia.com>
 <20111230032559.GB17850@core.coreip.homeip.net>
 <20120131190904.GA20672@core.coreip.homeip.net>
In-Reply-To: <20120131190904.GA20672@core.coreip.homeip.net>
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

Dmitry Torokhov wrote at Tuesday, January 31, 2012 12:09 PM:
> On Thu, Dec 29, 2011 at 07:25:59PM -0800, Dmitry Torokhov wrote:
> > On Fri, Dec 09, 2011 at 03:17:54PM -0800, Stephen Warren wrote:
> > > Dmitry Torokhov wrote at Friday, December 09, 2011 2:25 PM:
> > > > On Friday, December 09, 2011 12:10:43 PM Stephen Warren wrote:
> > > > > Shridhar Rasal wrote at Friday, December 09, 2011 12:29 AM:
> > > > > > To: dmitry.torokhov@gmail.com
> > > > > > Cc: rydberg@euromail.se; Stephen Warren; Rakesh Iyer;
> > > > > > linux-kernel@vger.kernel.org; linux- input@vger.kernel.org;
> > > > > > linux-tegra@vger.kernel.org; Shridhar Rasal Subject: [PATCH 1/1] input:
> > > > > > keyboard: Set configuration registers
> > > > > >
> > > > > > -Set only REQUIRED row and column configuration register to
> > > > > > PROPER values to avoid continuously generating KBC input events.
> > > > > > -Use *en* field in pin_cfg, to check GPIO_x_ROW_EN register
> > > > > > should be set or clear.
> > > > > >
> > > > > > Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
> > > > >
> > > > > I wondered if num==0 could be used instead of a new en field, but 0 is a
> > > > > valid row/column number, so no. As such,
> > > > >
> > > > > Acked-by: Stephen Warren <swarren@nvidia.com>
> > > >
> > > > Can we pass in number of pin_cfg instances in pdata and simply do not
> > > > mention unneeded pins instead?
> > >
> > > IIUC, the array is currently a fixed size (based on the set of pins
> > > Supported by the KBC), hence that won't work; there's an entry for each
> > > pin saying which row/column it is.
> > >
> > > However, I suppose if we were to change the structure of the pdata to be:
> > >
> > > struct tegra_kbc_pin_cfg {
> > >     bool is_row;
> > >     u8 row_col_id;
> > >     u8 pin_id;
> > > };
> > >
> > > Then struct tegra_kbc_platform_data could indeed have a pointer to a
> > > variable-sized array of these, which would avoid the "en" member.
> > >
> >
> > How about we change bool to enum instead, like in the patch below?
> 
> *ping*

That's conceptually fine by me. I was assuming you were asking Rakesh...

I'd rather PIN_CFG_IGNORE was the first enum, so it gets value 0, or this
probably won't solve the original issue?

-- 
nvpublic

