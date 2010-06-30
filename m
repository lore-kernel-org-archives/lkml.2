Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0F3WSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:18:16 -0400
Received: from xenotime.net ([72.52.115.56]:40436 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752754Ab0F3WSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:18:15 -0400
Date: Wed, 30 Jun 2010 15:18:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kees Bakker <kees.bakker@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: Filename case conflict Documentation/io-mapping.txt and
 Documentation/IO-mapping.txt
Message-Id: <20100630151806.08a1823c.rdunlap@xenotime.net>
In-Reply-To: <97A9C0E5-DA16-4C78-89A3-BBC08EF16518@xs4all.nl>
References: <97A9C0E5-DA16-4C78-89A3-BBC08EF16518@xs4all.nl>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 22:58:21 +0200 Kees Bakker wrote:

> Hi,
> 
> Do we really want these two filenames as they are right now?
> We have:
>    Documentation/IO-mapping.txt
>    Documentation/io-mapping.txt
> 
> kees@plankie:~/src/linux-2.6$ git blame Documentation/IO-mapping.txt|head
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   1) [ NOTE: The virt_to_bus() and bus_to_virt() functions have been
> 5872fb94 (Randy Dunlap      2009-01-29 16:28:02 -0800   2) 	superseded by the functionality provided by the PCI DMA interface
> 5872fb94 (Randy Dunlap      2009-01-29 16:28:02 -0800   3) 	(see Documentation/PCI/PCI-DMA-mapping.txt).  They continue
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   4) 	to be documented below for historical purposes, but new code
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   5) 	must not use them. --davidm 00/12/12 ]
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   6) 
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   7) [ This is a mail message in response to a query on IO mapping, thus the
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   8)   strange format for a "document" ]
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700   9) 
> ^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700  10) The AHA-1542 is a bus-master device, and your patch makes the driver give the
> 
> kees@plankie:~/src/linux-2.6$ git blame Documentation/io-mapping.txt|head
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  1) The io_mapping functions in linux/io-mapping.h provide an abstraction for
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  2) efficiently mapping small regions of an I/O device to the CPU. The initial
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  3) usage is to support the large graphics aperture on 32-bit processors where
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  4) ioremap_wc cannot be used to statically map the entire aperture to the CPU
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  5) as it would consume too much of the kernel address space.
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  6) 
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  7) A mapping object is created during driver initialization using
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  8) 
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700  9) 	struct io_mapping *io_mapping_create_wc(unsigned long base,
> 9663f2e6 (Keith Packard 2008-10-30 19:38:18 -0700 10) 						unsigned long size)
> 
> So the IO-mapping.txt was there first. Keith, can't we rename your
> file? For example,
> 
>    Documentation/io-mapping.txt => Documentation/io-mapping.h.txt
> -- 

Alternatively:

$ git mv Documentation/IO-mapping.txt Documentation/bus-virt-phys-mapping.txt

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
