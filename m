Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2IEL5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:57:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31316 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2IEL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:57:45 -0400
Date: Wed, 5 Sep 2012 07:57:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com, rob@landley.net,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: Add dma map/unmap error tracking support
Message-ID: <20120905115722.GC5400@localhost.localdomain>
References: <1346595257.4377.5.camel@lorien2>
 <20120904210555.GG3155@phenom.dumpdata.com>
 <1346799476.3130.27.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346799476.3130.27.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 04:57:56PM -0600, Shuah Khan wrote:
> On Tue, 2012-09-04 at 17:05 -0400, Konrad Rzeszutek Wilk wrote:
> > On Sun, Sep 02, 2012 at 08:14:17AM -0600, Shuah Khan wrote:
> > > A recent dma mapping error analysis effort showed that a large precentage
> > > of dma_map_single() and dma_map_page() returns are not checked for mapping
> > > errors. Reference: https://lkml.org/lkml/2012/8/10/326
> > > 
> > 
> > So were you able to catch some naughty drivers with this?
> 
> I did compile a complete list of drivers that don't check dma mapping
> errors from my analysis. Are you interested in seeing the full analysis?

Yes, plus the authors of the drivers are probably interested in it as
well.
..snip..
> > I was initially thinking that this patch would contain a state for the driver
> > of whether after map it has called dma_mapping_error. So this function would
> > increment some internal state, and if dma_mapping_error on that specific dma_addr
> > it would decrement it. If it never occured, then we would print on the unmap
> > that the device never had called dma_mapping_error on said dma_addr?
> 
> That is a good idea. Let me see if I understand what you are saying
> correctly. Add a new field to dma_debug_entry structure and keep state
> and clear it if dma_mapping_error() is called. This will require adding
> a debug interface for dma_mapping_error() which is not hard to do. Is
> this close to what you are thinking?

Right. It is more complex than this patch but it should provide a nicer
"trap" mechanism to alert driver writers that they are not checking DMA
addresses properly.
