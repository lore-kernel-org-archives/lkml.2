Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0I3KIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:08:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52325 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab0I3KIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:08:18 -0400
MIME-Version: 1.0
In-Reply-To: <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
References: <4CA391B3.1030806@wol.de> <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Sep 2010 12:08:02 +0200
Message-ID: <AANLkTik0DXVYgiDV0zy-m4kcsvX6X3j-8sGW4H_YT+x6@mail.gmail.com>
Subject: Re: [PATCH] Fix capi devicenames
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Marc - A. Dahlhaus" <mad@wol.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:30, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 29 Sep 2010 21:21:23 +0200
> "Marc - A. Dahlhaus" <mad@wol.de> wrote:
>
>> capi device names should get changed to what userspace expects.
>
> If userspace isn't following the spec (which has been the spec for many
> years) then thats not our problem.
>
>> Without this change recent udev versions can't produce working device
>> nodes as the capi control device node name "capi" collides with the
>> "capi" directory under which userspace expects to get the application
>> device nodes. This also fixes the Documentation.
>
> The documentation isn't broken, the documentation *is* the reference.
>
> NAK. Fix udev.
>
> We have a spec for a reason, if some distro didn't follow it then that's
> up to them but they can sort out their own udev.

There is nothing really to fix in udev, it knows nothing about ISDN.
The kernel defines the device node names these day, and udev manages
only permissions and possible symlinks.

devices.txt is just wrong in some things, and the common userspace
usage pattern is much closer to be a 'standard' here than this file.
devices.txt should catch up here. The same is true for scdX vs. srX,
scdX nodes don't exist today, and srX is not at all deprecated, unlike
devices.txt states.

The kernel provided ISDN nodes never made sense for applications using
ISDN. Also the devices.txt node names, I've never seen anywhere else
than in devices.txt.

The patch looks sane to me.

Kay
