Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2GXRIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:08:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2GXRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
Date: Wed, 25 Jul 2012 01:08:36 +0800
Message-ID: <CACVXFVN+nfeurwFoHLK0T2OhPG56ZzTi8mXfbsomcB0YWgkviA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 1:00 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi,
>
> In [1][2], the problem below has been discussed for some time:
>
>         device's firmware may be lost during suspend/resume
>         cycle because device is unplugged and plugged again
>         or device experiences system power loss in the period.
>         but during resume path, system is still not ready(process
>         frozen, rootfs not usable, ...) to complete loading firmware
>         from user space for the device
>
> The conclusion is that caching firmware during suspend/resume cycle
> is capable of solving the problem.
>
> This patchset implements cache/uncache firmware mechanism,
> and apply the mechnism to cache device's firmware in kernel memory
> space automatically during suspend/resume cyclye, so device can
> load its firmware easily during resume path. When resume is completed
> and system is ready, the cached firmwares will be removed from
> kernel memory later.

$git diff --stat
 drivers/base/devres.c         |   42 +++
 drivers/base/firmware_class.c |  749 +++++++++++++++++++++++++++++++++++------
 include/linux/device.h        |    3 +
 include/linux/firmware.h      |   15 +
 4 files changed, 705 insertions(+), 104 deletions(-)


Thanks,
--
Ming Lei
