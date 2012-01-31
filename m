Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2AaTvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:51:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17752 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2AaTvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:51:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 31 Jan 2012 11:51:38 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Shridhar Rasal <srasal@nvidia.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 31 Jan 2012 11:51:36 -0800
Subject: RE: [PATCH 1/1] input: keyboard: Set configuration registers
Thread-Topic: [PATCH 1/1] input: keyboard: Set configuration registers
Thread-Index: AczgUTN7l86POhHZSOS/GJYt5VoN6gAAFZPg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E1244B3@HQMAIL01.nvidia.com>
References: <1323415758-16822-1-git-send-email-srasal@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1751860550@HQMAIL01.nvidia.com>
 <3849551.l2KNPKMSmh@dtor-d630.eng.vmware.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17518605E5@HQMAIL01.nvidia.com>
 <20111230032559.GB17850@core.coreip.homeip.net>
 <20120131190904.GA20672@core.coreip.homeip.net>
 <74CDBE0F657A3D45AFBB94109FB122FF178E1244A2@HQMAIL01.nvidia.com>
 <20120131194735.GA22872@core.coreip.homeip.net>
In-Reply-To: <20120131194735.GA22872@core.coreip.homeip.net>
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

Dmitry Torokhov wrote at Tuesday, January 31, 2012 12:48 PM:
> On Tue, Jan 31, 2012 at 11:29:35AM -0800, Stephen Warren wrote:
> > Dmitry Torokhov wrote at Tuesday, January 31, 2012 12:09 PM:
> > > On Thu, Dec 29, 2011 at 07:25:59PM -0800, Dmitry Torokhov wrote:
> > > > On Fri, Dec 09, 2011 at 03:17:54PM -0800, Stephen Warren wrote:
...
> > > > > However, I suppose if we were to change the structure of the pdata to be:
> > > > >
> > > > > struct tegra_kbc_pin_cfg {
> > > > >     bool is_row;
> > > > >     u8 row_col_id;
> > > > >     u8 pin_id;
> > > > > };
> > > > >
> > > > > Then struct tegra_kbc_platform_data could indeed have a pointer to a
> > > > > variable-sized array of these, which would avoid the "en" member.
> > > > >
> > > >
> > > > How about we change bool to enum instead, like in the patch below?
...
> > I'd rather PIN_CFG_IGNORE was the first enum, so it gets value 0, or this
> > probably won't solve the original issue?
> 
> The benefit of current definition is that it is compatible with old
> ones using bool...

There are no in-tree users of this type yet, so compatibility isn't
really an issue. And if we don't make that change, anyone who does start
to use it is going to have to initialize every element of the array even
when they aren't used.

-- 
nvpublic

