Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab1LQAXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:23:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46682 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1LQAW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:22:59 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: checkpatch.pl misreporting bugs with array fillings
Date: Sat, 17 Dec 2011 01:22:55 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
References: <201112162259.29043.marek.vasut@gmail.com> <1324080955.331.16.camel@joe2Laptop>
In-Reply-To: <1324080955.331.16.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112170122.55827.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2011-12-16 at 22:59 +0100, Marek Vasut wrote:
> > static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
> > 
> >         {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> >         {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > 
> > };
> 
> True.
> 
> Andy will probably figure it out.
> He's the maintainer.
> 
> Still, in this case all the 0's are unnecessary.
> I'd probably write that code as:
> 
> static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
> 	{ [7] = 27, [8] = 27 },
> 	{ [7] = 29, [8] = 29 },
> };

I suspect this is some remnant of ancient code where the people writing it were 
not sure if the memory under this is all-zeroes. (or the section this lands in 
wasn't zeroed-out)

M
