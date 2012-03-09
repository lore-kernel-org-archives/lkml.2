Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2CIGmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:42:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51617 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2CIGmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo72gJAPvyvo6EpcuEwqFaZQ_viUrgLAuA0CHttuxXkCXw@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-3-git-send-email-yinghai@kernel.org>
	<CAErSpo72gJAPvyvo6EpcuEwqFaZQ_viUrgLAuA0CHttuxXkCXw@mail.gmail.com>
Date: Thu, 8 Mar 2012 22:42:51 -0800
X-Google-Sender-Auth: Ph7tUh8DvD_dqvk03k5J2NrjEJM
Message-ID: <CAE9FiQUVCM4BTxV6qNa0a73bHrgYXWj_Y0Ys9WnJn6jBKiXM0w@mail.gmail.com>
Subject: Re: [PATCH 02/23] PCI, sysfs: create rescan_bridge under
 /sys/.../pci/devices/... for pci bridges
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 4:52 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Current code will create rescan for every pci device under parent bus.
>> that is not right. the device is already there, there is no reason to rescan it.
>>
>> We could have rescan for pci bridges. less confusing.
>
> Yes, but now we have *three* rescan attributes for a single bridge/bus:
>
>    /sys/devices/pci0000:00/0000:00:01.0/pci_bus/0000:01/rescan

no, that one is not there, and should not be added.

But I do suggest to add
/sys/devices/pci0000:00/0000:00:01.0/pci_bus/0000:01/remove

>    /sys/devices/pci0000:00/0000:00:01.0/rescan_bridge
>    /sys/devices/pci0000:00/0000:00:01.0/rescan
>
> and this for an endpoint:
>
>    /sys/devices/pci0000:00/0000:00:05.0/rescan
>
> I think endpoints should not have a "rescan" attribute at all, and
> bridges should have only a "rescan" attribute (not "rescan" and
> "rescan_bridge").

agreed,  that rescan actually is doing rescan of it's parent bus.

I have suggested to remove it. but Alex said some HP internal
application will need
that, so it can not be removed.

at last I have to use rescan_bridge for bridge device.

>
> I'm not sure about "pci_bus/.../rescan".  I know you didn't add that,
> but I'm not sure it makes sense to have both that and a "rescan" on
> the bridge device.  If we have both, what's the difference between
> them?

rescan : for device parent bus, that is really weird.
rescan_bridge: will only show up that device is bridge, and rescan that bridge.

Yinghai
