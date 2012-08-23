Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab2HWPbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:31:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39105 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2HWPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
 <CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 23 Aug 2012 17:31:08 +0200
Message-ID: <CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
Subject: Re: udev 182: response timeout for request_firmware in module_probe path
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 5:16 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Tue, Aug 21, 2012 at 1:34 PM, Ming Lei <tom.leiming@gmail.com> wrote:

>> I found that udev 182 doesn't response for the request_firmware in
>> module_probe path until 30sec later after the 'ADD' event of firmware
>> device, but no such problem in udev175, sounds like a regression of udev?
>
> Looks udevd is capable of handling the firmware ADD event even though
> the device ADD event is being processed( modprobe is triggered by device
> ADD event).

Calling out from inside the kernel and blocking in a firmware loading
userspace transaction during module_init() is kind of weird.

The firmware loading call should not rely on a fully functional
userspace, and modprobe should not hang and block until the firmware
request is handled.

The firmware should be requested asynchronously or from a different
context as module_init(). It depends on the type of driver/hardware
what's the best approach here.

Thanks,
Kay
