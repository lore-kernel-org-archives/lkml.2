Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2IRXtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:49:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62292 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab2IRXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:49:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5LMj=wPwYgJfk97hfx9b03fPHZXEvdR6gV2somBTD+4A@mail.gmail.com>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
	<1347670122-25824-3-git-send-email-yinghai@kernel.org>
	<CAErSpo5LMj=wPwYgJfk97hfx9b03fPHZXEvdR6gV2somBTD+4A@mail.gmail.com>
Date: Tue, 18 Sep 2012 16:49:49 -0700
X-Google-Sender-Auth: UGC3oIfEsO1ou3yWNaDgcnAaxe8
Message-ID: <CAE9FiQUxt1kx_SpRWt5eMKvUXuUXwJrd9USeT+WMbCWkDDaQZQ@mail.gmail.com>
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 3:46 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Sep 14, 2012 at 6:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Found one system one root bus hot remove get panic.
>> Panic happens when try to release hostbridge resource.
>>
>> It turns out that resource get reject during put into resource tree
>> because of conflicts.
>> Also that resource parent pointer have random value.
>>
>> That invalid value cause it pass through check __release_pci_root_info
>> and panic in release_resource.
>>
>> Try to use kzalloc instead.
>
> Don't we need the same fix for ia64 in pci_acpi_scan_root()?  Here's
> what it does:
>
>         if (windows) {
>                 controller->window =
>                         kmalloc_node(sizeof(*controller->window) * windows,
>                                      GFP_KERNEL, controller->node);
>


yes, but they don't support pci_set_host_bridge_release yet. so they
should not meet this problem yet.

Thanks

Yinghai
