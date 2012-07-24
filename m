Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2GXRAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:00:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58760 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2GXRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:00:38 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
Date: Wed, 25 Jul 2012 01:00:00 +0800
Message-Id: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In [1][2], the problem below has been discussed for some time:

	device's firmware may be lost during suspend/resume
	cycle because device is unplugged and plugged again
	or device experiences system power loss in the period.
	but during resume path, system is still not ready(process
	frozen, rootfs not usable, ...) to complete loading firmware
	from user space for the device

The conclusion is that caching firmware during suspend/resume cycle
is capable of solving the problem.

This patchset implements cache/uncache firmware mechanism,
and apply the mechnism to cache device's firmware in kernel memory
space automatically during suspend/resume cyclye, so device can
load its firmware easily during resume path. When resume is completed
and system is ready, the cached firmwares will be removed from
kernel memory later.

Even there are some corener cases[3] which can't be solved this cache
approach, but as Linus pointed, the driver should use some specific
way to fix it, for example, the isight camera problem can easily be
solved with deferral probe by driver explicitly, see [1], and some
patches will be posted later to do it.


[1]. http://marc.info/?t=134278790800004&r=1&w=2
[2]. http://marc.info/?t=132528956000002&r=10&w=2
[3]. http://marc.info/?l=linux-usb&m=132554118928398&w=2

Thanks,
--
Ming Lei


