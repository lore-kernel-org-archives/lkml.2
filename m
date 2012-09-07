Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2IGQUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:20:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43374 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750746Ab2IGQUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:20:35 -0400
Date: Fri, 7 Sep 2012 12:20:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Shuah Khan <shuah.khan@hp.com>
cc: fujita.tomonori@lab.ntt.co.jp, Andrew Morton <akpm@linux-foundation.org>,
        <paul.gortmaker@windriver.com>, <bhelgaas@google.com>,
        <amwang@redhat.com>, <joerg.roedel@amd.com>,
        <paul.gortmaker@windriver.com>, <kubakici@wp.pl>,
        <dan.carpenter@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <shuahkhan@gmail.com>
Subject: Re: [RFC] DMA mapping error check analysis
In-Reply-To: <1347033200.2603.19.camel@lorien2>
Message-ID: <Pine.LNX.4.44L0.1209071218550.1674-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2012, Shuah Khan wrote:

> I analyzed all calls to dma_map_single() and dma_map_page() in the
> kernel, to see if callers check for mapping errors, before using the
> returned address.
> 
> The goal of this analysis is to find drivers that currently do not 
> check dma mapping errors, and fix them.
> 
> I documented the results of this analysis:
> 
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> 
> Please review and give me feedback on the analysis and the proposed
> next steps.

Your first table (dma_map_single) lists drivers/usb/core/usb.c and
marks it as Bad.  This is a mistake because the code is #ifdef'ed out.  
It hasn't been used in many years; it should be removed.

Alan Stern

