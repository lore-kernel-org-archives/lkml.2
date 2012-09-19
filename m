Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2ISPeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:34:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2ISPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:34:19 -0400
Message-ID: <5059E5F3.2040809@gmail.com>
Date: Wed, 19 Sep 2012 23:34:11 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org> <1347670122-25824-3-git-send-email-yinghai@kernel.org> <CAErSpo5LMj=wPwYgJfk97hfx9b03fPHZXEvdR6gV2somBTD+4A@mail.gmail.com> <CAE9FiQUxt1kx_SpRWt5eMKvUXuUXwJrd9USeT+WMbCWkDDaQZQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUxt1kx_SpRWt5eMKvUXuUXwJrd9USeT+WMbCWkDDaQZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:49 AM, Yinghai Lu wrote:
> On Tue, Sep 18, 2012 at 3:46 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Sep 14, 2012 at 6:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Found one system one root bus hot remove get panic.
>>> Panic happens when try to release hostbridge resource.
>>>
>>> It turns out that resource get reject during put into resource tree
>>> because of conflicts.
>>> Also that resource parent pointer have random value.
>>>
>>> That invalid value cause it pass through check __release_pci_root_info
>>> and panic in release_resource.
>>>
>>> Try to use kzalloc instead.
>>
>> Don't we need the same fix for ia64 in pci_acpi_scan_root()?  Here's
>> what it does:
>>
>>         if (windows) {
>>                 controller->window =
>>                         kmalloc_node(sizeof(*controller->window) * windows,
>>                                      GFP_KERNEL, controller->node);
>>
> 
> 
> yes, but they don't support pci_set_host_bridge_release yet. so they
> should not meet this problem yet.
Hi Yinghai,
	We are trying to add pci_set_host_bridge_release() for IA64, so would
appreciate it if you could help to fix IA64 too.
	--Gerry

