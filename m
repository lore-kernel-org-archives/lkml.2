Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0DIU2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:28:16 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:50084 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0DIU2O (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 9 Apr 2010 16:28:14 -0400
Date: Fri, 9 Apr 2010 16:25:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Daniel Mack <daniel@caiaq.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: [LKML] Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100409202533.GA8983@phenom.dumpdata.com>
References: <w2r74fd948d1004091119j9f33d8a6kc1824d9243abf38b@mail.gmail.com> <Pine.LNX.4.44L0.1004091529240.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004091529240.1852-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBF8DA2.0064:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:34:06PM -0400, Alan Stern wrote:
> On Fri, 9 Apr 2010, Pedro Ribeiro wrote:
> 
> > > The DMA pointers do indeed look sane. I wanted to take a deeper look at
> > > this and set up a 64bit system today. However, I fail to see the problem
> > > here. Pedro, how much RAM does your machine have installed?
> 
> > It has 4 GB.
> 
> That means DMA mapping cannot be the cause of the problem.  :-(

That isn't entirely true. The BIOS usually allocates a 256 MB ACPI/PCI hole
that is under the 4GB.

So end up with 3.7 GB, then the 256MB hole, and then right above the 4GB
you the the remaining memory: 4.3GB.

