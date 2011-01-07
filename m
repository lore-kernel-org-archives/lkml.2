Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1AGWcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:32:13 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:51179 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754080Ab1AGWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:32:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=edvOdEJ5n8yrcDVXFfGpdtE1z4mSZNK1HyTwbiqyr4KKDx59mnIwf2BORj15N1b8zr0cZ5qNGpj+i/6Ta7oV0ZFLKuhfAcXoop59+9I520hbMd0eNSYASUXWjQ+4mIjU;
Date: Fri, 7 Jan 2011 14:32:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
Subject: Re: [PATCH 1/1] PCI: ignore failure to preallocate minimal
 resources to hotplug bridges
Message-ID: <20110107143208.036a3c01@jbarnes-desktop>
In-Reply-To: <20101022171640.GE24820@ram-laptop>
References: <20101006225834.GE2945@ram-laptop>
	<201010081416.57454.bjorn.helgaas@hp.com>
	<20101012070515.GA549@ram-laptop>
	<201010121301.54402.bjorn.helgaas@hp.com>
	<20101018131010.0e4771eb@jbarnes-desktop>
	<20101019171740.GC8437@ram-laptop>
	<20101019112439.53c4901e@jbarnes-desktop>
	<20101022171640.GE24820@ram-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 10:16:40 -0700
Ram Pai <linuxram@us.ibm.com> wrote:

>         PCI: ignore failure to preallocate minimal resources to 
> 		hotplug bridges
> 
> 	Linux tries to pre-allocate minimal resources to hotplug 
> 	bridges.  This 	works 	fine as long as there are enough 
> 	resources  to  satisfy   all   other   genuine  resource
> 	requirements.  However  if  enough  resources   are  not 
> 	available    to    satisfy    the    pre-allocation, the 
> 	resource-allocator reports errors and returns failure.
> 	
> 	This patch distinguishes between must-need resources and
> 	nice-to-have   resources.   Any   failure   to  allocate 
> 	nice-to-have resources are ignored. 
> 
> 	This  behavior  can  be  particularly  useful to trigger 
> 	automatic  reallocation, if  the  OS  discovers  genuine 
> 	resource  allocation  conflicts  or  genuine unallocated 
> 	BARs  caused  by not-so-smart allocation behavior of the 
> 	native BIOS.
> 
> 	The motivation for this patch is due a issue reported in 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=15960
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> 

Seems like we want a fix like this; did you see Bjorn's comments?
Maybe we can adjust the order of allocation instead?

What issues do you still have outstanding wrt resource allocation?  Do
you still think you need the big "reallocate everything" option?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
