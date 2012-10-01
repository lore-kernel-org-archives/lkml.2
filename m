Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2JAIHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:07:51 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:33603
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab2JAIHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:07:48 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB7FWS-02-01B-02
X-M-MSG: 
Date: Mon, 1 Oct 2012 10:05:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/16] iommu/amd: Add initialization routines for AMD
 interrupt remapping
Message-ID: <20121001080541.GM4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-13-git-send-email-joerg.roedel@amd.com>
 <CAKocOONojx7tvu6x+HV97Rae-KXA3hW65Ujmt2t7LCVs9oRpyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKocOONojx7tvu6x+HV97Rae-KXA3hW65Ujmt2t7LCVs9oRpyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:18:18PM -0600, Shuah Khan wrote:
> > +void amd_iommu_disable(void)
> > +{
> > +       amd_iommu_suspend();
> 
> Is it safe to attempt to suspend when iommu is in suspend state? In
> other words what happens if amd_iommu_disable() gets called when iommu
> is already in suspend state?

Yes, this is safe. It just trns a bit to 0 which is already 0.

>> > +int amd_iommu_reenable(int mode)
> > +{
> > +       amd_iommu_resume();
> 
> Same question as above. Safe to do a resume, when in resumed state?

Safe too, it just writes values to the hardware which are already there.
This was also proven by testing.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

