Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2AVSDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:03:25 -0500
Received: from mail.vyatta.com ([76.74.103.46]:57765 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab2AVSDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:03:24 -0500
Date: Sun, 22 Jan 2012 10:03:21 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Regression: sky2 kernel between 3.1 and 3.2.1 (last known good
 3.0.9)
Message-ID: <20120122100321.0e8bf958@nehalam.linuxnetplumber.net>
In-Reply-To: <4F1AD9E1.8030203@majjas.com>
References: <20100120094103.GA6225@ff.dom.local>
	<4B58B217.8030001@majjas.com>
	<20100121204133.GB3085@del.dom.local>
	<4B59E7EB.3050605@majjas.com>
	<4F1452B1.4010200@majjas.com>
	<20120120082659.1e06853e@nehalam.linuxnetplumber.net>
	<4F1999DC.3050308@majjas.com>
	<4F1AD9E1.8030203@majjas.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Not sure how I can do any sort of bisect without narrowing down the 
> possible culprits.


The error is resulting from hardware trying to access un mapped memory.
You could instrument the dmar_fault() code to print out more fault information
(address, type, etc) and then dump request ring in sky2.

Also, since it is rare, it maybe related to your hardware not mapping all
the bits of address.

Jan 16 05:49:46 mail kernel: [198230.628919] DRHD: handling fault status 
reg 2
Jan 16 05:49:46 mail kernel: [198230.628925] sky2 0000:06:00.0: error 
interrupt status=0x80000000
Jan 16 05:49:46 mail kernel: [198230.628929] DMAR:[DMA Read] Request 
device [06:00.0] fault addr fff78000
Jan 16 05:49:46 mail kernel: [198230.628931] DMAR:[fault reason 06] PTE 
Read access is not set
Jan 16 05:49:46 mail kernel: [198230.628939] sky2 0000:06:00.0: PCI 
hardware error (0x2010)
