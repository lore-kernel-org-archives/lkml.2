Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144Ab2KVTR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:17:58 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57954 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2KVTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:17:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121121145239.GA21860@kroah.com>
References: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca> <20121121145239.GA21860@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 22 Nov 2012 20:17:32 +0100
Message-ID: <CAPXgP12fOANaeVQ=8ZMd1q-SdJo0xjsGoVTqs27oe44wXuSCdQ@mail.gmail.com>
Subject: Re: [RFC] driver-core: Remove dummy 'platform_bus'
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 3:52 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 21, 2012 at 02:44:31PM +0000, Grant Likely wrote:
>> The "platform_bus" (note: not platform_bus_type) only exists as an empty
>> directory to put platform devices into. However, it really doesn't make
>> sense to segregate all the platform devices into a sub directory when
>> typically they are memory mapped devices that doen't go through any
>> particular bus. Particularly on embedded type platforms the platform_bus
>> directory doesn't add anything.
>>
>> However, this will probably just end up breaking some userspace that
>> depends on the /sys/devices/platform/ path to be present (no matter how
>> much we protest that userspace must not depend on paths in sysfs). So
>> while I'm seriously proposing this change, it may just be unacceptable
>> ABI breakage
>
> If the devices don't show up under platform/ where are they going to be
> at now, virtual/ ?  That doesn't sound like a good plan, they should be
> somewhere "useful".

Just a note to keep in mind: We usually need and want devices to have
a bus or class. Devices without a "subsystem" are invisible to udev,
and do not get proper coldplug support at bootup.

Kay
