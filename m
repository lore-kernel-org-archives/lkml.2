Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2I0KUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:20:24 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:46619
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab2I0KUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:20:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIzz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB07DO-01-MWC-02
X-M-MSG: 
Date: Thu, 27 Sep 2012 12:20:11 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: <konrad.wilk@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <rob@landley.net>, <akpm@linux-foundation.org>,
        <bhelgaas@google.com>, <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devel@linuxdriverproject.org>, <x86@kernel.org>,
        <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120927102011.GF10549@amd.com>
References: <1347843171.4370.13.camel@lorien2>
 <1348621517.3091.6.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1348621517.3091.6.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

the patch looks better then the older versions. It comes closer to a
merge, but I see one issue here:

On Tue, Sep 25, 2012 at 07:05:17PM -0600, Shuah Khan wrote:
> debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr):
> 	Sets dma map error checked status for the dma map entry if one is
> 	found. Decrements the system wide dma_map_errors_not_checked counter
> 	that is incremented by debug_dma_map_page() when it checks for
> 	mapping error before adding it to the dma debug entry table.

It is problematic that the DMA debug code can no longer call
dma_mapping_error because of this. How about adding a special version of
that function which does no checking and use it in the DMA debug code
instead?


Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

