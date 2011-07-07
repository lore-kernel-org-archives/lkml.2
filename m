Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1GGUKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:10:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32070 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1GGUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:10:49 -0400
Date: Thu, 7 Jul 2011 16:09:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: xen-devel@lists.xensource.com, jeremy.fitzhardinge@citrix.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix
Message-ID: <20110707200949.GA25216@dumpdata.com>
References: <20110703232508.GB4440@Xye>
 <1309769388.634.51.camel@zakaz.uk.xensource.com>
 <20110704221646.GB4490@Xye>
 <20110705141323.GG2972@dumpdata.com>
 <20110705142731.GA4463@Xye>
 <20110705144846.GA13548@dumpdata.com>
 <20110705213243.GA3647@dumpdata.com>
 <20110707154648.GA4394@Xye>
 <20110707162454.GA8164@dumpdata.com>
 <20110707194851.GB4394@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707194851.GB4394@Xye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E161299.0091:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 01:18:51AM +0530, Raghavendra D Prabhu wrote:
> * On Thu, Jul 07, 2011 at 12:24:54PM -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >>Tested it. Works now.
> >
> >Ok, Stuck Tested-by on the patch. Hopefully Linus hasn't pulled it yet.
> Ok.
> >
> >>Reviewed-by: Raghavendra Prabhu <rprabhu@wnohang.net>
> 
> >>Also,
> >>The condition for acpi_gsi_to_irq can be removed since it always returns zero.
> >
> >The function might in the future return something that is non-zero
> >and we should guard for it. Also you make 'irq' be unsigned which is not
> >good as the IRQ 0 is a valid value - and with making it unsigned if it is
> >set to -1 (the -1 is the invalid IRQ value) the check for 'irq != gsi'
> >will be true and and we will pass in -1 casted to unsigned. That is a
> >large value and not the right thing we want to pass to xen_register_gsi.
> 
> My rationale for the unsigned part was that acpi_gsi_to_irq always
> assigns a positive value (>= 0) to the irq passed (as unsigned
> argument). But even otherwise that shouldn't make much of difference I guess.
> 
> Also,
> I had sent another change (oneline) for the file
> arch/x86/xen/platform-pci-unplug.c for check_platform_magic, looks like that has not gone into
> the pull request for Linus.

Oh, I didn't see it. Did you CC me on it? Can you bounce it to me please?
