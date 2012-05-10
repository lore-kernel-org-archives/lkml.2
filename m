Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2EJSW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:22:56 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40305 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2EJSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:22:54 -0400
Message-ID: <1336674019.16730.239.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 1/7] ACPI: Add CONFIG_HOTPLUG_OST option
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 12:20:19 -0600
In-Reply-To: <4FABFE33.9040502@gmail.com>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	  <1336507944-10219-2-git-send-email-toshi.kani@hp.com>
	  <4FABEF90.4040602@gmail.com> <1336670790.16730.215.camel@misato.fc.hp.com>
	 <4FABFE33.9040502@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 01:43 +0800, Jiang Liu wrote:
> On 05/11/2012 01:26 AM, Toshi Kani wrote:
> > On Fri, 2012-05-11 at 00:40 +0800, Jiang Liu wrote:
> >> On 05/09/2012 04:12 AM, Toshi Kani wrote:
> >>> Added CONFIG_ACPI_HOTPLUG_OPT option. When this config option is disabled,
> >>> this patchset has no effect on the platform. This option is disabled by
> >>> default. The dependency list assures consistent behavior among CPU, memory
> >>> and container hotplug operations with regarding the _OST support.
> >> Seems also need to enhance the acpiphp driver for PCI hotplug operations too.
> >> acpiphp driver is also based on the ACPI device hotplug model.
> > 
> > Good question.  ACPI PCI hotplug is a legacy method, which is being
> > replaced by PCI native hotplug.  I expect PCI native hotplug will be
> > used for any platforms supporting PCI-E.  Since this _OST support is
> > targeted for new platforms (as _OST is not supported on the current
> > platforms), I thought that it would be prudent to avoid changing PCI
> > hotplug code for this.
> You are right, acpiphp is legacy method. But it may also be used to support
> some cases which can't be supported by the pciehp driver.
> For example, we have a PCIe system which needs to run acpiphp and pciehp
> concurrently. The pciehp driver is used to manage hot-pluggable PCIe slot,
> and the acpiphp driver is used to migrate downstream ports among virtual 
> PCIe switches of an MR-IOV switch. It would be great if we could enable 
> _OST for acpiphp too.
> 
> To be honest, our BIOS doesn't provide _OST for acpiphp yet, so we could
> enhance acpiphp driver in future when a system really needing that feature
> appears.

Interesting.  In such case, I am willing to change acpiphp, but I am
afraid that I do not have access to platforms with ACPI PCI hotplug
support.  My test systems are all PCI-E based.  So, it would be great if
you could enhance acpiphp when you need it.


Thanks!
-Toshi

