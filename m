Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2CBKAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:00:25 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62206 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2CBKAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:00:23 -0500
Date: Fri, 2 Mar 2012 11:00:12 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120302100012.GA31314@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120302074800.C2F973E17BE@localhost>
References: <20120302074800.C2F973E17BE@localhost>
  <cover.1329396583.git.rubini@gnudd.com>
 <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Grant for your comments. Agreed with all of them.

>> +	/* 384 was used in previous code: be compatible for other drivers */
>> +	err = irq_alloc_descs(-1, 384, GSTA_NR_GPIO, NUMA_NO_NODE);
> 
> That's a lot of irqs.  Will they all be used?

384 is the starting point, isn't it? The number is 128. One per gpio pin.
We have change-detect for mmc and other stuff that live in high gpio
numbers.

> How do other drivers determine which irq number to use (is it
> statically assigned, or is there a dynamic mechanism)?  If only a
> portion are used, then the irq_domain linear mapping would be a win
> here.

The code I received uses static numbers. The chip is the main chipset
in the typical use case, so only one is there even if it is PCI.  I
also have a PCIe card to use it as slave device, and I'm careful to
allow several of them, even if it's not the main use case. Maybe here
I fell short. I'm reposting soon, with a full change log.

This "compatibility" is something I need to run the boards with
existing code for the parts that are not cleaned up for upstream, yet.

/alessandro
