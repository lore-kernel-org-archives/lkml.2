Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0HBIc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:32:59 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19853 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab0HBIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:32:57 -0400
X-SpamScore: -29
X-BigFish: VS-29(zz1102K1432N98dN936eMzz1202hzz15d4Rz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6INQR-02-34D-02
X-M-MSG: 
Date: Mon, 2 Aug 2010 10:35:57 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100802083556.GC29744@amd.com>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
 <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
 <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <1280546124.1902.30.camel@pasglop>
 <20100802074812.GM24084@amd.com>
 <1280736182.1902.55.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280736182.1902.55.camel@pasglop>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 04:03:02AM -0400, Benjamin Herrenschmidt wrote:
> On Mon, 2010-08-02 at 09:48 +0200, Roedel, Joerg wrote:
> > > Hrm, indeed I just noticed that. Pretty gross... it should definitly
> > be
> > > renamed, is will caused endless confusion with unrelated iommu.h and
> > > iommu_* interfaces which represent something different.
> > 
> > The first direction to go should be trying to unify all the different
> > iommu* interfaces into the iommu-api. The generic api will definitly
> > need to be extended for that, but since it is an in-kernel interface
> > thats no problem. 
> 
> Well, I suppose I'm the de-facto candidate to take care of the powerpc
> side then :-)
> 
> I don't have the bandwidth right now, but I'll try to have a look when
> time permits.

Btw. I have some ideas to extend the IOMMU-API to also support GART-like
IOMMUs. These pieces could also support (limited-size) domains (without
isolation) using segmentation. Not sure if this makes sense for the
use-cases in other architectures but we should not declare this
impossible for now.

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

