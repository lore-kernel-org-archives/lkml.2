Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2JIOzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:55:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2JIOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121009123629.GB11061@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
	<20121009041947.GB8237@opensource.wolfsonmicro.com>
	<CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
	<20121009071343.GW8237@opensource.wolfsonmicro.com>
	<CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com>
	<20121009074138.GB8237@opensource.wolfsonmicro.com>
	<CACVXFVONtkA5tUq3zcvrn6+RmC0_VLgeK5aR7g8yV2dJbgCysA@mail.gmail.com>
	<20121009123629.GB11061@opensource.wolfsonmicro.com>
Date: Tue, 9 Oct 2012 22:55:17 +0800
Message-ID: <CACVXFVNZPxG3pNnQfSEqvPvLV3LoutFCX_0eZpwjAWEwd8RByA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with vmalloc()
From: Ming Lei <ming.lei@canonical.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 8:36 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Oct 09, 2012 at 08:02:18PM +0800, Ming Lei wrote:
>
>> If loading via user space, timeout or not depends on userspace,
>> at least udev won't timeout on non-existent firmware image.
>
> This may be a mdev or old udev thing...  it's definitely prevelant.

I just checked history of udev, and looks it can't timeout on
non-existent firmware file, even with the oldest shell script of
firmware.sh.

Also looks mdev of busybox checks firmware file too before loading.

IMO, firmware loader can't help the problem if userspace
chooses to timeout on non-existent file. Maybe you have to
depend on direct loading.

>
>> Also looks request_firmware_nowait() is better for the case, _nowait()
>> can avoid unnecessary delay and speedup firmware loading if there
>> are more than one firmware to load.
>
> It doesn't really help as the ABI is such that you can only have one

Could you let me know where the ABI is?

> request_firmware() in play at once (unless this changed since I last
> looked at it).

I guess you mean that only one firmware device can be added
as child of the device which is requesting firmware.

The commit below(already merged into linus tree) should fix
the problem:

    99c2aa72306079976369aad7fc62cc71931d692a(firmware loader:
    fix creation failure of fw loader device)

Could you test it to see if more than one request_firmware_nowait()
can be called concurrently for the same device?

Thanks,
--
Ming Lei
