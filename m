Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab0JGAav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:30:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57876 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab0JGAat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:30:49 -0400
Date: Wed, 6 Oct 2010 17:30:41 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource
 allocation
Message-ID: <20101007003041.GF2945@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20101006225834.GE2945@ram-laptop>
 <20101006233953.GB16280@helgaas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006233953.GB16280@helgaas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 05:39:53PM -0600, Bjorn Helgaas wrote:
> On Wed, Oct 06, 2010 at 03:58:34PM -0700, Ram Pai wrote:
> >         PCI: override BIOS/firmware memory resource allocation
> > 		through command line parameters
> > 
> > 	Platforms that are unaware of  SRIOV  BARs  fail to allocate MMIO
> > 	resources  to SRIOV PCIe  devices. Hence  on  such  platforms the
> > 	OS fails to  enable  SRIOV.
> > 	Some  platforms  where  BIOS/uEFI resource   allocations  conflict
> > 	the conflicting devices are disabled.
> > 
> > 	Ideally we  would  want  the  OS  to detect and fix automatically
> > 	such problems and conflicts.  However previous  attempts to do so
> > 	have led to regression on legacy platforms.
> 
> I'm sorry to be a nay-sayer, but I think we just haven't tried hard
> enough.  Our ACPI/PCI/e820 resource management is not well integrated,
> and I suspect if we straightened that out, we could avoid some of the
> regressions we saw with previous attempts.

Can you be more specific as to what can be done to fix it automatically?

Neither accepting this approach nor telling what needs to be straightened out
to automatically fix all the systems out there, is just a deadend.

The choice is between
	(a) an automated patch with the risk of regressing some platforms.
	(b) an semi-automated patch that does not regress *any* platform,
		with the ability to fix platforms that are currently broken.
	(c) status quo, which means broken platforms continue to be so.

I thought the initial proposal was to use (b), with the long
term goal of fixing it automatically, assuming that it is even possible.

Let me know if that is *not* the goal and I will change directions.
RP
