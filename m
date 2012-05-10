Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2EJQhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:37:00 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:13647 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2EJQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:36:58 -0400
Message-ID: <1336667664.16730.201.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 3/7] ACPI: Add _OST support for sysfs eject
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 10:34:24 -0600
In-Reply-To: <1336664428.2581.21.camel@lorien2>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	 <1336507944-10219-4-git-send-email-toshi.kani@hp.com>
	 <1336581973.2498.15.camel@lorien2>
	 <1336587377.16730.150.camel@misato.fc.hp.com>
	 <1336664428.2581.21.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 09:40 -0600, Shuah Khan wrote:
> On Wed, 2012-05-09 at 12:16 -0600, Toshi Kani wrote:
> 
> > > > 
> > > > Added macro definitions of _OST source events and status codes.
> > > > Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
> > > > since this _OSC bit is not specific to CPU hotplug. This bit is
> > > > defined in Table 6-147 of ACPI 5.0 as follows.
> 
> Sorry. Missed that. It was in patch 7. Any reason why this feature is
> split across 7 patches? Might be better to combine patches 1, 2, and 7
> as it contains the infrastructure type code for _OST. Something to
> consider.

Bjorn suggested, which I agreed, that the OS should call _OSC with
hotplug _OST bit set when the OS is in fact capable of supporting _OST.
Hence, patch 7/7 needs to be the last patch in the patchset.


> There is no functional change with this patch set in the sense that _OST
> doesn't get evaluated on platforms that don't support _OST, however
> there is run-time change on all architectures with patches 3, 4, and 5.
> There are couple of new kfree() calls introduced. Something to take a
> closer to make sure it is safe in that path.

Yes, the changes have been verified closely as required for any code
changes.  I have also added comments to acpi_bus_hot_remove_device() to
clarify the kfree()s.


> Also, what missing functionality does evaluating _OST add to the kernel?
> What happens if OS continues to not evaluate _OST? It is an optional
> method, looking for what is the value add?

_OST is the ACPI standard method for the platform to receive the status
of hotplug operations.  Some platforms may require the OS to support
_OST in order to support ACPI hotplug operations.  For instance, if the
platform has the management console where user can request a hotplug
operation from, this _OST support would be required for the management
console to show the result of a hotplug request to user.  


Thanks,
-Toshi

