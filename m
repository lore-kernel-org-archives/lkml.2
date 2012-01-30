Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2A3Sjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:39:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55637 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2A3Sja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:39:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4d=HW9Lk+O8Kz6BzQZY1DpF1OEuD37RwABgT3m03LB3Q@mail.gmail.com>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org>
	<1327718971-9598-4-git-send-email-yinghai@kernel.org>
	<CAErSpo4d=HW9Lk+O8Kz6BzQZY1DpF1OEuD37RwABgT3m03LB3Q@mail.gmail.com>
Date: Mon, 30 Jan 2012 10:39:29 -0800
X-Google-Sender-Auth: 2hb8AUruHCvFFVfazqrSC3S6ICU
Message-ID: <CAE9FiQUGd3FoxiLOx4cHr0e9EJBtSA=oVq4eXbtdw+0vi5QZrA@mail.gmail.com>
Subject: Re: [PATCH 03/13] PCI: Add busn_res tracking in core
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 7:35 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jan 27, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> update pci_scan_root_bus, and pci_scan_bus to insert root bus busn into
>> iobusn_resource tree.
>> -struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>> -               struct pci_ops *ops, void *sysdata, struct list_head *resources)
>> +struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
>> +               int bus_max, struct pci_ops *ops, void *sysdata,
>> +               struct list_head *resources)
>
> We are adding "scan root bus" interfaces at an alarming rate (I'm
> responsible for most of them, so I'm not blaming you :)).  Could we
> get away without adding this one by just adding a bus number resource
> to the "resources" list?  For example, then an arch could do:
>
>    LIST_HEAD(resources);
>    pci_add_resource(resources, bus_window);
>    pci_add_resource(resources, mem_window);
>    pci_add_resource(resources, io_window);
>    pci_scan_root_bus(..., resources);
>
> If pci_scan_root_bus() didn't find a bus number resource in the list,
> it could fall back to a default max_bus of 255.
>

this pci_scan_root_bus_max is only used for x86 code.  and should be
fixed later.

Yinghai
