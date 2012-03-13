Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2CMGWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:22:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54086 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326Ab2CMGWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F5E1D11.8050101@gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
	<1331362837-10740-20-git-send-email-yinghai@kernel.org>
	<4F5E1D11.8050101@gmail.com>
Date: Mon, 12 Mar 2012 23:22:12 -0700
X-Google-Sender-Auth: hZeQgIA4THCyMVO_70d3sBB5T-E
Message-ID: <CAE9FiQWM6+iGk0YNSgrvtZKjfxMbrxMYU_Qh0gAs1gLDtS8ZaQ@mail.gmail.com>
Subject: Re: [PATCH v2 19/37] PCI: Add pci_stop_and_remove_bus()
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +void pci_stop_and_remove_bus(struct pci_bus *bus)
>> +{
>> +     struct pci_host_bridge *host_bridge = NULL;
>> +     struct pci_dev *pci_bridge = NULL;
>> +
>> +     pci_stop_bus_devices(bus);
>> +
>> +     if (pci_is_root_bus(bus)) {
>> +             host_bridge = to_pci_host_bridge(bus->bridge);
>> +             pci_stop_host_bridge(host_bridge);
>> +     } else
>> +             pci_bridge = bus->self;
>> +
>> +     __pci_remove_bus_devices(bus);
>> +
>> +     pci_remove_bus(bus);
>> +
> It seems that the bus and host_bridge structures may have already been freed here,
> so should not access host_bridge structure any more.
>> +     if (host_bridge)
>> +             host_bridge->bus = NULL;
>> +

not really.

Yinghai
