Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610Ab1LQAQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:16:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35672 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752591Ab1LQAP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:15:58 -0500
Message-ID: <1324080955.331.16.camel@joe2Laptop>
Subject: Re: checkpatch.pl misreporting bugs with array fillings
From: Joe Perches <joe@perches.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Date: Fri, 16 Dec 2011 16:15:55 -0800
In-Reply-To: <201112162259.29043.marek.vasut@gmail.com>
References: <201112162259.29043.marek.vasut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 22:59 +0100, Marek Vasut wrote:
> static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
>         {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
>         {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> };

True.

Andy will probably figure it out.
He's the maintainer.

Still, in this case all the 0's are unnecessary.
I'd probably write that code as:

static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
	{ [7] = 27, [8] = 27 },
	{ [7] = 29, [8] = 29 },
};	


