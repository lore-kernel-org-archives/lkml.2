Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1GSIuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:50:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:7166 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1GSIuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:50:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,227,1309762800"; 
   d="scan'208";a="28855190"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Date: Tue, 19 Jul 2011 14:19:03 +0530
Subject: RE: [Query]: What should we do in txd->tx_submit() and
 device_issue_pending()
Thread-Topic: [Query]: What should we do in txd->tx_submit() and
 device_issue_pending()
Thread-Index: AcxF7gLdat5jZnjKTm+GSNvdL35NVAAAVpWQ
Message-ID: <438BB0150E931F4B9CE701519A4463010871D6C2EF@bgsmsx502.gar.corp.intel.com>
References: <4E254067.1060408@st.com>
In-Reply-To: <4E254067.1060408@st.com>
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

(pls wrap your email to 80lines, I have reflowed below for readability) 
> Hi Dan/Vinod,
> 
> I have one query regarding implementation of few routines in DMA drivers.
> 
> What the exact purpose of txd->tx_submit() and device_issue_pending() routines?
> 
> Should tx_submit() always start physical transfer (Obviously, if channel is
> free)? Or should it just queue requests and then finally a call to
> device_issue_pending() must start physical transfers?
(reflowed your email for 80lines)
tx_submit is not supposed to start the transfer, it is supposed to add the 
descriptors in dma driver's queue. The issue_pending is supposed to actually 
start the transfer. The reasons were well articulated is discussion we had 
when we did the DMA documentation.
Pls see https://lkml.org/lkml/2011/5/24/530

~Vinod
