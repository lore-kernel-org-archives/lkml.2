Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2AaOhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:37:48 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34060 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2AaOhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:37:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] sysfs:  Update the name hash when renaming sysfs entries
References: <4F27120A.4040106@suse.cz>
	<CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
	<4F27C54F.1010107@suse.cz>
	<CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
	<4F27C9D4.3040105@suse.cz>
	<CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com>
	<4F27CDBC.5020201@suse.cz>
	<CAPXgP1371fgmaP3ecxsDJ2BmJrOS6kUP95G1BHe6deBPk5FVCQ@mail.gmail.com>
	<m18vko6jmv.fsf@fess.ebiederm.org>
Date: Tue, 31 Jan 2012 06:40:26 -0800
In-Reply-To: <m18vko6jmv.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Tue, 31 Jan 2012 06:18:00 -0800")
Message-ID: <m1zkd45411.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18X2RmM2lqzS7MwXyUMDHvgfhugM8mWl58=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a bug introduced with sysfs name hashes where renaming a
network device appears to succeed but silently makes the sysfs files for
that network device inaccessible.

In at least one configuration this bug has stopped networking from
coming up during boot.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ea64d01..dd3779c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -872,6 +872,7 @@ int sysfs_rename(struct sysfs_dirent *sd,
 
 		dup_name = sd->s_name;
 		sd->s_name = new_name;
+		sd->s_hash = sysfs_name_hash(sd->s_ns, sd->s_name);
 	}
 
 	/* Move to the appropriate place in the appropriate directories rbtree. */
-- 
1.7.2.5


