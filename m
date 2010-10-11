Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0JKPDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:03:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0JKPDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:03:20 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 11 Oct 2010 10:03:07 -0500
Subject: RE: [PATCHv3 00/11] staging tidspbridge: iommu migration
Thread-Topic: [PATCHv3 00/11] staging tidspbridge: iommu migration
Thread-Index: ActooSgsWB8aKtDkRdCpPFwjK3+taAAss3Sg
Message-ID: <496565EC904933469F292DDA3F1663E602F47B2BB1@dlee06.ent.ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
 <AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
In-Reply-To: <AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
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

 

> -----Original Message-----
> From: Felipe Contreras [mailto:felipe.contreras@gmail.com] 
> Sent: Sunday, October 10, 2010 12:33 PM
> To: Guzman Lugo, Fernando
> Cc: gregkh@suse.de; felipe.contreras@nokia.com; 
> ameya.palande@nokia.com; Menon, Nishanth; 
> Hiroshi.DOYU@nokia.com; ohad@wizery.com; 
> linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv3 00/11] staging tidspbridge: iommu migration
> 
> On Tue, Oct 5, 2010 at 11:35 PM, Fernando Guzman Lugo 
> <x0095840@ti.com> wrote:
> > This set of patches remove the dspbridge custom mmu 
> implementation and 
> > use iommu module instead.
> 
> I have tried this, it works for simple tests, but not real use-cases.
> I applied all your iommu patches. How did you test this?

Have you applied:

- "scatterlist: define SG chain for arm architecture"
- "iovmm: replace __iounmap with omap_iounmap"
- "iovmm: add superpages support to fixed da address"
- "iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF"
- "iovmm: no gap checking for fixed address"

Also make sure your baseline have this patch:

- "omap:iommu-load cam register before flushing the entry"


What kind of error are you getting?

I don't have a complete framework to test MM testcases at this moment
I did not stress test but a bridge level, and they were good, just some
Mailbox issues beucase of the lack of some patches. So I was waiting
All missing patches are merge in order to do more stressing testing because
I think there is some race conditions in iommu module that need to be fixed.

You can email me the case and erros you are facing privately and I will
Check them, maybe it is because of missing patches.

Regards,
Fernando.

> 
> --
> Felipe Contreras
> 