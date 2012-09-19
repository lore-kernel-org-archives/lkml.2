Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2ISNMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:12:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39783 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab2ISNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUxt1kx_SpRWt5eMKvUXuUXwJrd9USeT+WMbCWkDDaQZQ@mail.gmail.com>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
 <1347670122-25824-3-git-send-email-yinghai@kernel.org> <CAErSpo5LMj=wPwYgJfk97hfx9b03fPHZXEvdR6gV2somBTD+4A@mail.gmail.com>
 <CAE9FiQUxt1kx_SpRWt5eMKvUXuUXwJrd9USeT+WMbCWkDDaQZQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 19 Sep 2012 07:12:27 -0600
Message-ID: <CAErSpo7DJgtxCF2ubw4rwxcSQh-BkivQLJDsqJOGU32pcmTTnw@mail.gmail.com>
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
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

Why should we wait to fix that bug until later?  I'm not interested in
debugging this in the future.  If you fix a bug, you should always try
to fix other occurrences of the same bug at the same time.
