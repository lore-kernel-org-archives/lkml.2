Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1ARWMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:12:02 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48415 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1ARWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:12:00 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/1] PCI: allocate essential resources before reserving hotplug resources
Date: Tue, 18 Jan 2011 15:11:14 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
References: <20101006225834.GE2945@ram-laptop> <201101181352.08013.bjorn.helgaas@hp.com> <20110118214253.GA10069@ram-laptop>
In-Reply-To: <20110118214253.GA10069@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101181511.16343.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 18, 2011 02:42:53 pm Ram Pai wrote:
> On Tue, Jan 18, 2011 at 01:52:06PM -0700, Bjorn Helgaas wrote:

> > This is a PCI-specific issue, so I'm not comfortable adding add_size
> > to struct resource.  That penalizes all resource users while only
> > helping PCI.  Also, the struct resource lives forever, and the
> > add_size information is only useful while we're configuring the
> > bridge.
> 
> Any suggestion on how to do this without adding a field to struct resource?

It *is* a little ugly.  You compute some of this info early, in
pbus_size_io/mem(), but it's not used until later.  Maybe it would
make sense in struct pci_bus?  That's a pain, too, because then you
have to test the resource type in adjust_resources_sorted() but at
least it's a per-PCI bridge structure.

Bjorn
