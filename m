Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2BDQro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:47:44 -0500
Received: from imr4.ericy.com ([198.24.6.9]:52941 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab2BDQrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:47:42 -0500
Date: Sat, 4 Feb 2012 08:45:52 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Aaron Sierra <asierra@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120204164552.GA31713@ericsson.com>
References: <1328298346.2261.196.camel@groeck-laptop>
 <eab6c0bf-4908-454c-b7fa-606e70050793@zimbra>
 <20120204094543.75e3c0b6@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120204094543.75e3c0b6@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 03:45:43AM -0500, Jean Delvare wrote:
> Hi Aaron,
> 
> On Fri, 03 Feb 2012 16:50:28 -0600 (CST), Aaron Sierra wrote:
> > I received and applied your patches. I had to compile with ACPI
> > disabled because 3.3-rc2 now reports a resource conflict between the
> > WDAT structure (that we report for Microsoft Windows watchdog timer
> > support) and the TCO watchdog portion of lpc_ich:
> > 
> > ACPI Warning: 0x00000460-0x0000047f SystemIO conflicts with
> > Region \PMIO 1 (20120111/utaddress-251)
> > ACPI: If an ACPI driver is available for this device, you should use
> > it instead of the native driver
> > lpc_ich: probe of 0000:00:1f.0 failed with error -16
> > 
> > We may have to submit a driver in the future to utilize the WDAT
> > ACPI table, but that's another topic.
> > 
> > Do you think it's worth modifying lcp_ich to register all of the
> > resources that it can and only populate the mfd_cells that have
> > all of their required resources? That would prevent the entire
> > driver from bombing out in situations like this. I can't imagine
> > our BIOS is the only one implementing the WDAT table.
> 
> Yes, definitely. One subdevice being unavailable shouldn't have any
> impact on other subdevices. The lpc_sch driver suffers from the same

Definitely agree.

The gpio driver needs some rework in initialization and cleanup
to correctly reserve and release its io regions.

Aaron, Peter, do you have time to look into that, or do you want me
to take a stab and send you diffs ?

Thanks,
Guenter
