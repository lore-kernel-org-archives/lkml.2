Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2ENKG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:06:59 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:41467 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab2ENKG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:06:57 -0400
Date: Mon, 14 May 2012 12:06:45 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: broonie@opensource.wolfsonmicro.com
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120514100645.GA5712@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120514095800.GL31985@opensource.wolfsonmicro.com>
References: <20120514095800.GL31985@opensource.wolfsonmicro.com>
  <20120514094737.GB2189@sirena.org.uk>
  <20120511233402.43D813E0791@localhost>
  <cover.1334219873.git.rubini@gnudd.com>
  <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
  <20120514072534.GA29871@mail.gnudd.com>
  <20120514095111.GA4972@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you use platform data why would you get unpredicatable numbers?

Because I request the irq numbers from the gpio driver (now I request
a free slot starting from 384, because previous drivers had it
hardwired).  So if the gpio driver requests a slot starting from 0 it
may get different values -- in general I can't now what it gets.

So the irq number is unknown at compile time, and can't be written in
the platform data.

Actually, the problem is there in any case if you plug two chips in
the same computer -- this is extremely unlikely because the sta2x11 is
currently only used as a motherboard chipset.  The thing must be
fixed in any case, because it's a pci device, but still using 384
allows me to use platform data for the current drivers that I'm running
until they are ported to upstream quality standards.

/alessandro
