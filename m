Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1EFBP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:15:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39249 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1EFBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=N+9ba5Cxyp7zzpucvOfQClwlDWp3YJ+1BO1/29qQ6pad3RlDdl6IcHH9bO/93JU4yt
         WKx/0Xwa8UEBU5aIRsjLLUjcIC9DMAHGi+hF2dgAdOdQxd4PqCvdnjrO7Lc+9jPcVqtH
         lpFmLI7Y1YY6Aj4abT7YK/4Uu8xRPQM/EA8xw=
MIME-Version: 1.0
In-Reply-To: <20110505202758.GA12812@kroah.com>
References: <1304595126.1284.3.camel@zag> <20110505202758.GA12812@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 May 2011 03:15:10 +0200
Message-ID: <BANLkTi=hkg9zucjPdCc38E5n5PvcHRw0kA@mail.gmail.com>
Subject: Re: [PATCH] reboot: disable usermodehelper to prevent fs access
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 22:27, Greg KH <greg@kroah.com> wrote:
> On Thu, May 05, 2011 at 01:32:05PM +0200, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: [PATCH] reboot: disable usermodehelper to prevent fs access
>>
>> In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
>> should be on every system, the kernel forks processes during
>> shutdown, which try to access the rootfs, even when the
>> binary does not exist. It causes exceptions and long delays in
>> the disk driver, which gets read requests at the time it tries
>> to shut down the disk.
>>
>> This patch disables all kernel-forked processes during reboot to
>> allow a clean poweroff.
>
> Should this also be backported to the -stable kernels as people are
> hitting this problem already today, right?

If it survives fine, I guess it's nothing that will hurt us in
-stable. Suspend/hibernate does the same thing for similar reasons
since a while. Nothing really should use /sbin/hotplug anymore. It
just does not scale with what we do today with kernel devices.

Old udev SYSV init scripts or initramfs used to disable it at bootup.
But recent init systems just don't care anymore. So it just popped up
with systemd, where udev is a plain native service without "legacy
disablement".

So, it might be nice for recently released kernels, on the other hand
it will not cause any problems or data-loos, just a nasty delay at
shutdown, because of a kernel config option UEVENT_HELPER_PATH that is
set wrong for today's systems.

Kay
