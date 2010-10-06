Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab0JFQTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:19:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52864 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0JFQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:19:03 -0400
Date: Wed, 6 Oct 2010 17:18:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
	time as methods
Message-ID: <20101006161854.GA30584@srcf.ucam.org>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com> <1286216549-5438-2-git-send-email-mjg@redhat.com> <201010060118.50875.rjw@sisk.pl> <4911F71203A09E4D9981D27F9D830858B4893B89@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4911F71203A09E4D9981D27F9D830858B4893B89@orsmsx503.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 09:14:07AM -0700, Moore, Robert wrote:

> Although there exists a single Windows document mentions this behavior as a windows "feature", I'm not 100% convinced that this is actually true. AFAIK, we've never seen a machine that depends on an "implicit notify" on a device when a wake GPE happens.

Such behaviour would be irrelevant for system sleep/wake - the only 
requirement is in runtime power management.

> It appears to me that the biggest issue right now is the fact that a Notify() must be performed on a Device object, and the problem is how to associate the GPE with the device object.

The other important aspect of this is that a single GPE may correspond 
to multiple devices. The methods will generally cope with this by either 
sending multiple notifies, executing some SMM code to identify the 
relevant device or reading PCI configuration registers to identify the 
source of the wakeup. We need to handle that case as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
