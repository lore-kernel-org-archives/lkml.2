Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2ENHZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:25:49 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:61168 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab2ENHZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:25:48 -0400
Date: Mon, 14 May 2012 09:25:34 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120514072534.GA29871@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120511233402.43D813E0791@localhost>
References: <20120511233402.43D813E0791@localhost>
  <cover.1334219873.git.rubini@gnudd.com>
 <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant. Sorry for the delay.

>> +	/* 384 was used in previous code: be compatible for other drivers */
>> +	err = irq_alloc_descs(-1, 384, GSTA_NR_GPIO, NUMA_NO_NODE);

> Where does the number 384 come from?  It looks like the driver only
> needs to allocate a range of irqs and that it doesn't actually matter
> what the real numbers are.  Can 0 be used instead?

The problem is that there are a number of drivers already working (but
not ready to be upstreamed), and we'd better continue using them.  So,
the mmc driver is requesting a specific interrupt number.  The code is
GPL (published on sourceforge) and I'd better remain compatible.

I'm not completely clear (yet) about how to get the right interrupt
number in those other drivers, but I'm willing to remove the constraint
as they are cleaned up and submitted.

> Actually, I'd rather see this driver switched to using
> irq_domain_add_linear so that irq_descs can be allocated on demand
> instead of all at once.  That way only gpios actually used for irqs
> get setup.

If it is a request, I'll evaluate it soon.  I assume an incremental
patch over what Samuel has already picked up is fine.

thanks
/alessandro
