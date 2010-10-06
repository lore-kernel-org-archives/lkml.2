Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab0JFTbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:31:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530Ab0JFTbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:31:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/5] ACPI: Allow handlers to be installed at the same time as methods
Date: Wed, 6 Oct 2010 21:30:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com> <4911F71203A09E4D9981D27F9D830858B4893B89@orsmsx503.amr.corp.intel.com> <20101006161854.GA30584@srcf.ucam.org>
In-Reply-To: <20101006161854.GA30584@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010062130.27564.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 06, 2010, Matthew Garrett wrote:
> On Wed, Oct 06, 2010 at 09:14:07AM -0700, Moore, Robert wrote:
> 
> > Although there exists a single Windows document mentions this behavior as a windows "feature", I'm not 100% convinced that this is actually true. AFAIK, we've never seen a machine that depends on an "implicit notify" on a device when a wake GPE happens.
> 
> Such behaviour would be irrelevant for system sleep/wake - the only 
> requirement is in runtime power management.
> 
> > It appears to me that the biggest issue right now is the fact that a Notify() must be performed on a Device object, and the problem is how to associate the GPE with the device object.
> 
> The other important aspect of this is that a single GPE may correspond 
> to multiple devices. The methods will generally cope with this by either 
> sending multiple notifies, executing some SMM code to identify the 
> relevant device or reading PCI configuration registers to identify the 
> source of the wakeup. We need to handle that case as well.

So, as I said, we can modify acpi_gpe_can_wake() to pass a device object to
ACPICA.  Then, the device object will be added to the list of devices to Notify()
if the GPE is signaled.  Plain and simple.

Thanks,
Rafael
