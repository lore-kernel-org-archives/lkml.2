Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0C3Sao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:30:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57145 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0C3Sam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:30:42 -0400
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, <netdev@vger.kernel.org>
Subject: [PATCH 0/6] tagged sysfs support
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Mar 2010 11:30:23 -0700
Message-ID: <m1fx3hk6gw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, netdev@vger.kernel.org, serue@us.ibm.com, bcrl@lhnet.ca, eric.dumazet@gmail.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, kay.sievers@vrfy.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The main short coming of using multiple network namespaces today
is that only network devices for the primary network namespaces
can be put in the kobject layer and sysfs.

This is essentially the earlier version of this patchset that was
reviewed before, just now on top of a version of sysfs that doesn't
need cleanup patches to support it.

I have been running these patches in some form for well over a
year so the basics should at least be solid.  

This patchset is currently against 2.6.34-rc1.

This patchset is just the basic infrastructure a couple of more pretty
trivial patches are needed to actually enable network namespaces to use this.
My current plan is to send those after these patches have made it through
review.

 drivers/base/class.c    |    9 ++++
 drivers/base/core.c     |   98 +++++++++++++++++++++++++++++++++----------
 drivers/gpio/gpiolib.c  |    2 +-
 drivers/md/bitmap.c     |    4 +-
 drivers/md/md.c         |    6 +-
 fs/sysfs/bin.c          |    2 +-
 fs/sysfs/dir.c          |  106 ++++++++++++++++++++++++++++++++++++-----------
 fs/sysfs/file.c         |   17 ++++---
 fs/sysfs/group.c        |    6 +-
 fs/sysfs/inode.c        |    6 ++-
 fs/sysfs/mount.c        |   91 +++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/symlink.c      |   35 ++++++++++++++-
 fs/sysfs/sysfs.h        |   23 ++++++++--
 include/linux/device.h  |    3 +
 include/linux/kobject.h |   26 +++++++++++
 include/linux/sysfs.h   |   18 ++++++++
 lib/kobject.c           |  104 ++++++++++++++++++++++++++++++++++++++++++++++
 17 files changed, 480 insertions(+), 76 deletions(-)

Eric
