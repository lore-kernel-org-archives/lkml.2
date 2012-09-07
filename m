Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2IGQyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:54:36 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:44900 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab2IGQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:54:33 -0400
Message-ID: <1347036869.2603.28.camel@lorien2>
Subject: Re: [RFC] DMA mapping error check analysis
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Alan Stern <stern@rowland.harvard.edu>
Cc: fujita.tomonori@lab.ntt.co.jp, Andrew Morton <akpm@linux-foundation.org>,
        paul.gortmaker@windriver.com, bhelgaas@google.com, amwang@redhat.com,
        joerg.roedel@amd.com, kubakici@wp.pl, dan.carpenter@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        shuahkhan@gmail.com
Date: Fri, 07 Sep 2012 10:54:29 -0600
In-Reply-To: <Pine.LNX.4.44L0.1209071218550.1674-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1209071218550.1674-100000@iolanthe.rowland.org>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 12:20 -0400, Alan Stern wrote:
> On Fri, 7 Sep 2012, Shuah Khan wrote:
> 
> > I analyzed all calls to dma_map_single() and dma_map_page() in the
> > kernel, to see if callers check for mapping errors, before using the
> > returned address.
> > 
> > The goal of this analysis is to find drivers that currently do not 
> > check dma mapping errors, and fix them.
> > 
> > I documented the results of this analysis:
> > 
> > http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> > 
> > Please review and give me feedback on the analysis and the proposed
> > next steps.
> 
> Your first table (dma_map_single) lists drivers/usb/core/usb.c and
> marks it as Bad.  This is a mistake because the code is #ifdef'ed out.  
> It hasn't been used in many years; it should be removed.

Thanks for catching it. I did note that in my research notes and that
was left out by mistake when I put the table together. Table is updated
now with your comment and marked it a Cleanup item.

-- Shuah

