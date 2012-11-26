Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2KZIfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:35:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45052 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2KZIfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:35:20 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [RFC][PATCH] fs: configfs: programmatically create config groups
Date: Mon, 26 Nov 2012 09:35:09 +0100
Message-id: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some parts of the kernel (e.g. planned configfs integration into usb
gadget) there is a need to programmatically create config groups
(directories) but it would be preferable to disallow creating them by
the user. This is more or less what default_groups used to be for.
But e.g. in the mass storage gadget, after storing the number of
luns (logical units) into some configfs attribute, the corresponding lun#
directories should be created, their number is not known up front so
default_groups are no good for this.

Example:

$ echo 3 > /cfg/..../mass_storage/luns

causes

/cfg/....../mass_storage/lun0
/cfg/....../mass_storage/lun1
/cfg/....../mass_storage/lun2

to be created. Yet

$ mkdir /cfg/..../mass_storage/<any name>

should not be allowed.

With create_group exported it is very easily achieved: make_group and make_item
are set to NULL in mass_storage's config_group, yet the kernel can
create_groups at will.

I kindly ask for comments. In particular, I would like to discuss
if this is the right approach. A counterpart to remove config groups
is also required. It is not implemented in this patch, though. What are
your opinions?

Andrzej Pietrasiewicz (1):
  fs: configfs: allow other kernel parts to programmatically create
    config groups

 fs/configfs/dir.c        |    5 +++--
 include/linux/configfs.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

