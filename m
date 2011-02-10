Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1BJPXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:23:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40012 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1BJPXV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Feb 2011 10:23:21 -0500
Date: Thu, 10 Feb 2011 10:22:43 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the xen-two tree
Message-ID: <20110210152243.GA12087@dumpdata.com>
References: <20110210154648.8b3b994e.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.1102101322450.31804@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102101322450.31804@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D5402DA.0040:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:24:58PM +0100, Thomas Gleixner wrote:
> On Thu, 10 Feb 2011, Stephen Rothwell wrote:
> 
> > Hi Konrad,
> > 
> > After merging the xen-two tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/gpio/langwell_gpio.c: In function 'lnw_irq_handler':
> > drivers/gpio/langwell_gpio.c:210: error: 'struct irq_desc' has no member named 'chip'
> > drivers/gpio/langwell_gpio.c:211: error: 'struct irq_desc' has no member named 'chip'
> > 
> > Caused by commit e22ff7614860bc282ba1eb25440d8fc56975e357 ("xen:
> > Interrupt cleanups").
> 
> Argh, it selects:
> 
> +       select GENERIC_HARDIRQS_NO_DEPRECATED
> 
> Konrad, I merily asked you to test XEN with that flag set, not to
> apply the change.

Whoops. Looks that I forgot to back out the change after I tested it. It is gone now.
