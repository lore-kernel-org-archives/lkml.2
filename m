Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab0HWM3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0HWM33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:29:29 -0400
Date: Mon, 23 Aug 2010 14:29:26 +0200
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2] loop: add some basic read-only sysfs attributes
Message-ID: <20100823122926.GC13712@nb.net.home>
References: <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> <4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> <20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> <20100729195616.GF1981@nb.net.home> <4C51E36F.6060906@redhat.com> <AANLkTimq0UVtR-ooutKTfOOE=cS-vxR4gR-aVc1feOzJ@mail.gmail.com> <4C52E013.7010105@redhat.com> <AANLkTik7DZ6-4UOTZnJiFJ5c19wGd4ko4Kc6zE7UMG8U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik7DZ6-4UOTZnJiFJ5c19wGd4ko4Kc6zE7UMG8U@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 04:34:43PM +0200, Kay Sievers wrote:
> On Fri, Jul 30, 2010 at 16:22, Milan Broz <mbroz@redhat.com> wrote:
> > On 07/30/2010 06:36 AM, Kay Sievers wrote:
> >
> >> Alternatively, these attributes could be created and removed/created
> >> with the ioctl, and before the 'change' event, only if there is an
> >> active backing file, but I would expect the attribute group at the
> >> device to work just fine.
> > I have no idea how you can add attribute group before add_disk() which
> > initializes kobj (it ends with BUG_ON in internal_create_group
> > - because !kobj->sd). Perhaps I missed something?
> 
> Attribute groups handle the creation of a kobject (subdir) for you,
> you only supply a name to the group. Without a name, they will put all
> the attributes in the root of the device.
> 
> The 'struct device' has a member **groups, and that can have a list of
> attribute groups assigned. You assign them before you register the
> device, and the core will take care of everything.
> 
> > Anyway, second approach works - now is loop attributes available only
> > when loop is configured and before CHANGE uevent is sent.
> >
> > Ok with that?
> 
> Sounds good, nothing to complain from a sysfs timing perspective.

Jens, ping... it would be really really nice to have this feature in 
kernel. 

The ioctls are useless and I'd like to minimize number of situations
where mount(8) behaviour depends on /etc/mtab.

Thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
