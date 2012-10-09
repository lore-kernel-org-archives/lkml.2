Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2JIMCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:02:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2JIMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <20121009074138.GB8237@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
	<20121009041947.GB8237@opensource.wolfsonmicro.com>
	<CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
	<20121009071343.GW8237@opensource.wolfsonmicro.com>
	<CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com>
	<20121009074138.GB8237@opensource.wolfsonmicro.com>
Date: Tue, 9 Oct 2012 20:02:18 +0800
Message-ID: <CACVXFVONtkA5tUq3zcvrn6+RmC0_VLgeK5aR7g8yV2dJbgCysA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with vmalloc()
From: Ming Lei <ming.lei@canonical.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 3:52 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> The point is that there's some firmware which the driver wants to load
> but where it's happy to continue if the user didn't provide one and
> doesn't want to introduce needless delays.

OK, I got it, thank you for sharing the use case.

If loading directly, the patch isn't needed because filp_open() can
return failure on non-existent file.

If loading via user space, timeout or not depends on userspace,
at least udev won't timeout on non-existent firmware image.

Also looks request_firmware_nowait() is better for the case, _nowait()
can avoid unnecessary delay and speedup firmware loading if there
are more than one firmware to load.

Thanks,
--
Ming Lei
