Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2I0ONP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:13:15 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:15422 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2I0ONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:13:13 -0400
Message-ID: <1348755190.2459.6.camel@lorien2>
Subject: Re: [PATCH v2] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        bhelgaas@google.com, stern@rowland.harvard.edu,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Date: Thu, 27 Sep 2012 08:13:10 -0600
In-Reply-To: <20120927102011.GF10549@amd.com>
References: <1347843171.4370.13.camel@lorien2>
	 <1348621517.3091.6.camel@lorien2> <20120927102011.GF10549@amd.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Thu, 2012-09-27 at 12:20 +0200, Joerg Roedel wrote:
> Hi Shuah,
> 
> the patch looks better then the older versions. It comes closer to a
> merge, but I see one issue here:
> 
> On Tue, Sep 25, 2012 at 07:05:17PM -0600, Shuah Khan wrote:
> > debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr):
> > 	Sets dma map error checked status for the dma map entry if one is
> > 	found. Decrements the system wide dma_map_errors_not_checked counter
> > 	that is incremented by debug_dma_map_page() when it checks for
> > 	mapping error before adding it to the dma debug entry table.
> 
> It is problematic that the DMA debug code can no longer call
> dma_mapping_error because of this. How about adding a special version of
> that function which does no checking and use it in the DMA debug code
> instead?

Yes. Konrad expressed the same concern and I understand the reasons.
Defining a special version of dma_mapping_error() will eliminate the
problem that prevents this routine being used from dma-debug api. Will
do that. Working on a v3 patch to fix this problem as well as the other
review comments from Konrad. Hoping I can have it ready in by the end of
this week(end)

Thanks,
-- Shuah

