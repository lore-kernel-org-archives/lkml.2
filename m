Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0G2JWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:22:53 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:44150
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566Ab0G2JWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:22:50 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6BBD9-01-7MD-02
X-M-MSG: 
Date: Thu, 29 Jul 2010 11:25:04 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100729092503.GO26098@amd.com>
References: <20100729084018.GM26098@amd.com>
 <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
 <20100729090607.GN26098@amd.com>
 <20100729181412H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100729181412H.fujita.tomonori@lab.ntt.co.jp>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 05:14:49AM -0400, FUJITA Tomonori wrote:
> On Thu, 29 Jul 2010 11:06:08 +0200
> "Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:
> > I have no clue about the ARM iommus on the omap-platform. From a quick
> > look into the header file I see some similarities to the IOMMU-API. I am
> 
> ARM's iommu stuff might be more appropriate as the IOMMU-API than
> include/linux/iommu.h

Then lets add this functionality to the generic IOMMU-API.

> > also very open for discussions about how the IOMMU-API could be extended
> > to fit the needs of other platforms. Only because nobody has tried to
> > discuss about such an effort is no reason to push the IOMMU-API back.
> 
> Well, the reason (nobody has tried) might be that linux/iommu.h
> doesn't look something intended for the generic IOMMU-API.

How does it not look like a generic intention? The function names are
all generic and do not express that this API should only be used for
KVM. If you talk about the design of the API itself, it was designed for
the IOMMUs I was aware of at the time writing the API (in fact, the
initial design was not my own, it was a generalization of the VT-d
interfaces for KVM).
In other words it was a bottom-up approach to fit the needs of the time
it was written. But its an kernel-only API so we can easily change it
and extend it for other users/iommus when the need arises. I think this
is the way we should go instead of letting each architecture design
their own IOMMU-interfaces.

		Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

