Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2IEOfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:35:34 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15469 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2IEOfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:35:32 -0400
Message-ID: <1346855696.2589.7.camel@lorien2>
Subject: Re: [PATCH] dma-debug: Add dma map/unmap error tracking support
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com, rob@landley.net,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Wed, 05 Sep 2012 08:34:56 -0600
In-Reply-To: <20120905115722.GC5400@localhost.localdomain>
References: <1346595257.4377.5.camel@lorien2>
	 <20120904210555.GG3155@phenom.dumpdata.com>
	 <1346799476.3130.27.camel@lorien2>
	 <20120905115722.GC5400@localhost.localdomain>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 07:57 -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 04, 2012 at 04:57:56PM -0600, Shuah Khan wrote:
> > On Tue, 2012-09-04 at 17:05 -0400, Konrad Rzeszutek Wilk wrote:
> > > On Sun, Sep 02, 2012 at 08:14:17AM -0600, Shuah Khan wrote:
> > > > A recent dma mapping error analysis effort showed that a large precentage
> > > > of dma_map_single() and dma_map_page() returns are not checked for mapping
> > > > errors. Reference: https://lkml.org/lkml/2012/8/10/326
> > > > 
> > > 
> > > So were you able to catch some naughty drivers with this?
> > 
> > I did compile a complete list of drivers that don't check dma mapping
> > errors from my analysis. Are you interested in seeing the full analysis?
> 
> Yes, plus the authors of the drivers are probably interested in it as
> well.
> ..snip..

I compiled very detailed information on the nature of problems with dma
mapping error checking, ranging from not checking mapping errors to not
unmapping etc. I would like to share this information in such a way that
others can leverage the research I already did. One good way to
communicate this information would be on one of the kernel wikis. Ideas,
suggestions?

> > > I was initially thinking that this patch would contain a state for the driver
> > > of whether after map it has called dma_mapping_error. So this function would
> > > increment some internal state, and if dma_mapping_error on that specific dma_addr
> > > it would decrement it. If it never occured, then we would print on the unmap
> > > that the device never had called dma_mapping_error on said dma_addr?
> > 
> > That is a good idea. Let me see if I understand what you are saying
> > correctly. Add a new field to dma_debug_entry structure and keep state
> > and clear it if dma_mapping_error() is called. This will require adding
> > a debug interface for dma_mapping_error() which is not hard to do. Is
> > this close to what you are thinking?
> 
> Right. It is more complex than this patch but it should provide a nicer
> "trap" mechanism to alert driver writers that they are not checking DMA
> addresses properly.

I will go back and work on improving this patch. I will have to think
about how to track overflow buffer triggers as well without impacting
the production kernel. That is a separate effort.

-- Shuah


