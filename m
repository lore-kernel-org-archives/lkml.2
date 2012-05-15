Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2EOPLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:11:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45274 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965023Ab2EOPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:11:48 -0400
Date: Tue, 15 May 2012 16:14:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515161439.00e2de3c@pyramind.ukuu.org.uk>
In-Reply-To: <20120515143644.GD6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
	<20120515111255.GJ32036@redhat.com>
	<4FB23C09.7060300@suse.de>
	<20120515115917.GK32036@redhat.com>
	<20120515150015.5bf17aea@pyramind.ukuu.org.uk>
	<20120515143644.GD6948@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Phoenix BIOS (linked at the first mail of the thread) and it does not have
> enough info even for ATA.

<History lecture mode on>

In the beginning was the CMOS, and the CMOS was good.

Then people started adding extra drives and screwing around with mappings.

For this period there are a set of rituals (and I use the word
intentionally) for finding the geometry data and configuration mappings
which depend on which of the major religions your BIOS belonged to.

The entire thing got out of hand and so EDD was born

The base Phoenix spec is 1.1 not 3.0 and was published in 1995. It
assumes legacy mappings. It does have enough information for
compatibility mode ATA, which is all there was in the BIOS at the time.
Closely related to all this is the emergency of the Compaq/Phoenix/Intel
BIOS Boot Specification v1.01 (1996).

The follow on Phoenix spec is 3.0 (rev 0.8) and was published in
1998. That one addresses IEEE 1394 and some other bits. It does support
PCI bus device paths and lun identification to some extent but isn't
adequate for all complex topologies but is for most.

The T13 draft D3186 was published in 2000 and leads on to the EDD 4.0
proposal of 2008 which generally is what people consider EDD 3.0

So I think you have your specifications confused too.

I would suggest you read and compare the documents. In particular please
read Phoenix EDD 3.0 and pay attention to the sections 5.8-5.8.3 which
cover the device path and explain how EDD3.0 describes the actual device
to BIOS mapping. In particular the DPT interface path identifies the PCI
bus/devfn and the DPT device path identifiers if the unit is master or
slave.

In the absence of the device/interface path being entirely unique (or
indeed present at all) you use the DPTE words 0-3 to identify the mapping
for any SFF style ATA interface. This is sufficient to identify all non
MMIO configurations. The DPTE in 3.0 doesn't allow for pure MMIO
controllers. You just walk the address back to a device mapping and to
the controller/port in question.

</>



Alan
