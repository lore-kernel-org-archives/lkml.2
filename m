Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0G3OfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:35:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51509 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0G3OfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <4C52E013.7010105@redhat.com>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 
	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 
	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> 
	<20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> 
	<20100729195616.GF1981@nb.net.home> <4C51E36F.6060906@redhat.com> 
	<AANLkTimq0UVtR-ooutKTfOOE=cS-vxR4gR-aVc1feOzJ@mail.gmail.com> 
	<4C52E013.7010105@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 30 Jul 2010 16:34:43 +0200
Message-ID: <AANLkTik7DZ6-4UOTZnJiFJ5c19wGd4ko4Kc6zE7UMG8U@mail.gmail.com>
Subject: Re: [PATCH v2] loop: add some basic read-only sysfs attributes
To: Milan Broz <mbroz@redhat.com>
Cc: Karel Zak <kzak@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 16:22, Milan Broz <mbroz@redhat.com> wrote:
> On 07/30/2010 06:36 AM, Kay Sievers wrote:
>
>> Alternatively, these attributes could be created and removed/created
>> with the ioctl, and before the 'change' event, only if there is an
>> active backing file, but I would expect the attribute group at the
>> device to work just fine.
> I have no idea how you can add attribute group before add_disk() which
> initializes kobj (it ends with BUG_ON in internal_create_group
> - because !kobj->sd). Perhaps I missed something?

Attribute groups handle the creation of a kobject (subdir) for you,
you only supply a name to the group. Without a name, they will put all
the attributes in the root of the device.

The 'struct device' has a member **groups, and that can have a list of
attribute groups assigned. You assign them before you register the
device, and the core will take care of everything.

> Anyway, second approach works - now is loop attributes available only
> when loop is configured and before CHANGE uevent is sent.
>
> Ok with that?

Sounds good, nothing to complain from a sysfs timing perspective.

Now you have do decide if you prefer that over the attribute group
approach. :) The code with attribute groups, instead of custom kobject
stuff, might be a bit easier to understand.

Thanks,
Kay
