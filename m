Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393Ab0KQTZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:25:10 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:59574 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934924Ab0KQTZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:25:09 -0500
Date: Wed, 17 Nov 2010 12:24:49 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David John <davidjon@xenontk.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1 / rc2 Regression] PCI: Kernel Hangs On Boot
Message-ID: <20101117192449.GA12191@helgaas.com>
References: <4CE3F763.6080002@xenontk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE3F763.6080002@xenontk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 09:10:19PM +0530, David John wrote:
> Commit dc9887dc ("x86/PCI: allocate space from the end of a region, not
> the beginning") causes the kernel to hang on my Dell Inspiron 1545.
> 2.6.36 and booting with pci=nocrs works fine. Reverting this commit also
> works. I am attaching the kernel log and system iomem from the working
> 2.6.36. It hangs at this location consistently:
> 
> pci-stub: invalid id string ""
> ACPI: AC Adapter [AC] (on-line)
> input: Lid Switch as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> 
> < hang >
> 
> Let me know if you need any other info.

Thanks a lot for this report.  I opened this bugzilla:
    https://bugzilla.kernel.org/show_bug.cgi?id=23132
to track it.

Would you mind attaching the dmesg log from 2.6.37-rc2 with
commit dc9887dc reverted?  That should have a little more
information (PCI allocation closer to what fails, and also
more PNP resource information).

The PCI assignments Linux did are only for bridge windows,
and I don't see anything actually *using* those windows, so
I suspect they might conflict with an ACPI/PNP device, which
is what we're poking at when it hangs.

If you happen to have Windows on this box as well, an
Everest report (http://lavalys.com) would be interesting.
If not, no worries.

Thanks again,
  Bjorn
