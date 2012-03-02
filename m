Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030451Ab2CBR53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:57:29 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51080 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689Ab2CBR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:57:24 -0500
Date: Fri, 2 Mar 2012 18:57:19 +0100
From: Bastian Blank <waldi@debian.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
Message-ID: <20120302175719.GA1468@wavehammer.waldi.eu.org>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
	Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
	pkg-xen-devel@lists.alioth.debian.org,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>,
	Dave Jiang <dave.jiang@intel.com>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
 <20120127144737.GA27750@andromeda.dapyr.net>
 <20120219223125.GA820@burratino>
 <20120220181618.GD17566@burratino>
 <4F4891B8.9050008@goirand.fr>
 <20120302055715.GA692@burratino>
 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
 <20120302162159.GB31683@wavehammer.waldi.eu.org>
 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 08:44:00AM -0800, Dan Williams wrote:
> On Fri, Mar 2, 2012 at 8:21 AM, Bastian Blank <waldi@debian.org> wrote:
> > On Thu, Mar 01, 2012 at 10:42:44PM -0800, Dan Williams wrote:
> >> WARN_ON may work, but then kernel may be subject random hangs from missed
> >> i/o completions.
> ...actually descriptors completing too early.

The interrupt happens while the module is still loading, so most likely
directly after enabling them. There should be no request in flight yet.

What puzzles me is the mix of different data types in the ioatdma
driver:

| u64 completion = *chan->completion;
| unsigned long phys_complete = completion & ~0x3f;

The state is 64bit long, but is down converted to a 32bit value without
anything.

phys_complete (a 32 bit value) gets compared to struct
dma_async_tx_descriptor.phys, which is defined as dma_addr_t, a _64_ bit
value.

Bastian

-- 
... The prejudices people feel about each other disappear when they get
to know each other.
		-- Kirk, "Elaan of Troyius", stardate 4372.5
