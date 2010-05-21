Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0EUUUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 16:20:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53817 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0EUUUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 16:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <20100521193251.GP3991@agk-dp.fab.redhat.com>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> 
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> 
	<201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> 
	<20100521182325.GO3991@agk-dp.fab.redhat.com> <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com> 
	<20100521193251.GP3991@agk-dp.fab.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 21 May 2010 22:20:02 +0200
Message-ID: <AANLkTimrz9wyVKe0Mdabc_zylZt0JmpVxgf7ab2Bw55B@mail.gmail.com>
Subject: Re: [dm-devel] add devname module aliases to allow module on-demand 
	auto-loading
To: Kay Sievers <kay.sievers@vrfy.org>, Nikanth Karthikesan <knikanth@suse.de>,
       Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>, dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 21:32, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, May 21, 2010 at 08:51:49PM +0200, Kay Sievers wrote:
>> The kernel itself creates /dev/mapper/control today.
>
> Must have missed that patch:)
> Userspace lvm and dm code is certainly not tied to that today.
>
> The device node that userspace lvm and dm tools use is under the
> complete control of this userspace code: it chooses the name, and
> creates or fixes it if it doesn't already exist with the required
> properties: anything devtmpfs is relevant only if it guessed the
> right name that this *completely independent* userspace code
> chooses to use and already created it exactly as required.
>
> If we were to move to a fixed name for the control device and hand
> control of that name to the kernel, then obviously this userspace
> code would need adjusting to respect that.

Upstream udev has no primary device node naming anymore, it's all
controlled by the kernel. In fact, recent udev versions log errors if
userspace defines names which disagree with the kernel-provided names,
or the kernel-created nodes.

There is no "abstraction" anymore, the kernel defines the API today,
and device naming is 100% inside the kernel.

Udev's job is manage permissions, and to create meaningful symlinks
which may change during lifetime of a kernel device.

The primary kernel device name is always in sync with "dmesg",
"proc/sys" and "/dev" these days. Only the symlinks may change at any
time, reflecting the current state of the device.

Kay
