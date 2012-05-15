Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537Ab2EOPq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291Ab2EOPqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:46:55 -0400
Date: Tue, 15 May 2012 18:46:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515154641.GI6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
 <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
 <20120515150015.5bf17aea@pyramind.ukuu.org.uk>
 <20120515143644.GD6948@redhat.com>
 <20120515161439.00e2de3c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515161439.00e2de3c@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 04:14:39PM +0100, Alan Cox wrote:
> > Phoenix BIOS (linked at the first mail of the thread) and it does not have
> > enough info even for ATA.
> 
> <History lecture mode on>
> 
> In the beginning was the CMOS, and the CMOS was good.
> 
> Then people started adding extra drives and screwing around with mappings.
> 
> For this period there are a set of rituals (and I use the word
> intentionally) for finding the geometry data and configuration mappings
> which depend on which of the major religions your BIOS belonged to.
> 
> The entire thing got out of hand and so EDD was born
> 
> The base Phoenix spec is 1.1 not 3.0 and was published in 1995. It
> assumes legacy mappings. It does have enough information for
> compatibility mode ATA, which is all there was in the BIOS at the time.
> Closely related to all this is the emergency of the Compaq/Phoenix/Intel
> BIOS Boot Specification v1.01 (1996).
> 
> The follow on Phoenix spec is 3.0 (rev 0.8) and was published in
> 1998. That one addresses IEEE 1394 and some other bits. It does support
> PCI bus device paths and lun identification to some extent but isn't
> adequate for all complex topologies but is for most.
> 
> The T13 draft D3186 was published in 2000 and leads on to the EDD 4.0
> proposal of 2008 which generally is what people consider EDD 3.0
> 
> So I think you have your specifications confused too.
> 
There is Phoenix spec 3.0 and there are T13 EDD3.0/4.0. They are
incompatible and you can't tell which one specific BIOS actually use.
Everything is correct till now?

> I would suggest you read and compare the documents. In particular please
I have them both open right now.

> read Phoenix EDD 3.0 and pay attention to the sections 5.8-5.8.3 which
> cover the device path and explain how EDD3.0 describes the actual device
> to BIOS mapping. In particular the DPT interface path identifies the PCI
> bus/devfn and the DPT device path identifiers if the unit is master or
> slave.
> 
Those sections is what I am looking at. I skipped DPTE part probably
because I didn't see Linux actually using it and I agree that you can use
I/O port to figure master/slave. It does not help much since the
information is not exposed to userspace (because code support different
spec where this is not needed) and because Phonix spec does not support
many other modern interfaces. The spec even specifies USB as TBD :) SATA
is missing completely.

> In the absence of the device/interface path being entirely unique (or
> indeed present at all) you use the DPTE words 0-3 to identify the mapping
> for any SFF style ATA interface. This is sufficient to identify all non
> MMIO configurations. The DPTE in 3.0 doesn't allow for pure MMIO
> controllers. You just walk the address back to a device mapping and to
> the controller/port in question.
> 
> </>
> 
> 
> 
> Alan

--
			Gleb.
