Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2EXUmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:42:55 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:11385 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2EXUmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:42:54 -0400
Message-ID: <1337892003.16730.411.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 1/6] ACPI: Add an interface to evaluate _OST
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 14:40:03 -0600
In-Reply-To: <1337882980.2718.82.camel@lorien2>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337826324-16802-2-git-send-email-toshi.kani@hp.com>
	 <1337882980.2718.82.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 12:09 -0600, Shuah Khan wrote:
> On Wed, 2012-05-23 at 20:25 -0600, Toshi Kani wrote:
 :
> ACPI_HOTPLUG_OST is defined when all relevant ACPI hotplug operations,
> such as CPU, memory and container hotplug, are enabled. This assures
> consistent behavior among the hotplug operations with regarding the
> _OST support. When ACPI_HOTPLUG_OST is not defined, this function is
> a no-op.
> 
> ACPI PCI hotplug is not enhanced to support _OST at this time since it
> is a legacy method being replaced by PCIe native hotplug. _OST support
> for ACPI PCI hotplug may be added in future if necessary.
 :
> > +
> > +/* Enable _OST when all relevant hotplug operations are enabled */
> > +#if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
> > +	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
> > +	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
> > +	(defined(CONFIG_ACPI_CONTAINER) ||		\
> > +	 defined(CONFIG_ACPI_CONTAINER_MODULE))
> > +#define ACPI_HOTPLUG_OST
> > +#endif
> 
> Already covered in my general comments, but just in case:
> 
> This is restricted to a few of the possible cases _OST is intended for.
> What happens when a kernel is configed with all of the above and PCI and
> PCIe hotplug configs. _OST will only be evaluated in these cases,
> shouldn't OS evaluate _OST in all cases once it tells firmware it
> supports _OST in the case of Insertion/Ejection?

PCIe native hotplug is a non-ACPI based hotplug, and is not supported by
_OST.  ACPI PCI hotplug is being replaced by PCIe native hotplug, so it
is not supported as described in the change log.  Please see the email
below on this.
http://marc.info/?l=linux-acpi&m=133669547631220&w=2


Thanks,
-Toshi

