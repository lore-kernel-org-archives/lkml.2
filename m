Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2HUP3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:29:32 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:44284
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082Ab2HUP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:29:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202hzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h)
X-WSS-ID: 0M9430V-01-94E-02
X-M-MSG: 
Date: Tue, 21 Aug 2012 17:29:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 17/19] x86, msi: Introduce x86_msi.compose_msi_msg
 call-back
Message-ID: <20120821152918.GM2582@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-18-git-send-email-joerg.roedel@amd.com>
 <20120820140843.GA7732@phenom.dumpdata.com>
 <20120821084007.GL2582@amd.com>
 <20120821144256.GC20097@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120821144256.GC20097@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 10:42:57AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 21, 2012 at 10:40:07AM +0200, Joerg Roedel wrote:
> > The VT-d implementation uses it. This function is used to create the MSI
> > message for PCI devices and the HPET. When it is called for the HPET the
> > pdev parameter is NULL and hpet_id is valid.
> 
> Perhaps then a more generic term? 'void *platform_priv' ?

Doesn't work this way here. The Intel code detects on pdev==NULL that it
needs to use hpet_id. What could work is to split the code-paths between
pci_dev msi composition and the one for hpet.
But that approach has the downside of code duplication to some degree.


Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

