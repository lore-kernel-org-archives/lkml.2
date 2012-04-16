Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2DPHtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:49:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:26986 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab2DPHtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131338495"
Message-ID: <4F8BCF00.3020004@intel.com>
Date: Mon, 16 Apr 2012 15:49:20 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
References: <4F8790F6.5080408@intel.com> <201204132141.58063.rjw@sisk.pl>
In-Reply-To: <201204132141.58063.rjw@sisk.pl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 03:41 AM, Rafael J. Wysocki wrote:
>> > @@ -296,7 +296,8 @@ static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
>> >  
>> >  static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
>> >  {
>> > -	if (dev->pme_interrupt)
>> > +	/* PME interrupt isn't available in the D3cold case */
>> > +	if (dev->pme_interrupt && !dev->runtime_d3cold)
>
> This whole thing is wrong.  First off, I don't think that the runtime_d3cold
> flag makes any sense.  We already cover that in dev->pme_support.
> 
> Second, pme_interrupt means that the _root_ _port_, not the device itself will
> trigger an interrupt whenever the device sends the PME message to it (which
> very well may happen for a device in D3_cold woken up by an external signal).
> 

I rechecked this. The port does trigger PME interrupt, but after the WAKE# signal
restores device power. So my comments "PME interrupt isn't available in the D3cold
case" is wrong, but setup ACPI wakeup is still required.

Regards
Yan, Zheng
