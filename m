Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2A3V4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:56:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47289 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2A3V4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:56:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.8.193 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F27120A.4040106@suse.cz>
Date: Mon, 30 Jan 2012 22:56:26 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: sysfs regression: wrong link counts
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I cannot boot properly with this commit:
commit 524b6c5b39b931311dfe5a2f5abae2f5c9731676
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Dec 18 20:09:31 2011 -0800

    sysfs: Kill nlink counting.


1) network systemd rule doesn't start network
2) sensors complain:
   sensors_init: Kernel interface error

ad 2) look at what it does:
/* returns !0 if sysfs filesystem was found, 0 otherwise */
int sensors_init_sysfs(void)
{
        struct stat statbuf;

        snprintf(sensors_sysfs_mount, NAME_MAX, "%s", "/sys");
        if (stat(sensors_sysfs_mount, &statbuf) < 0
         || statbuf.st_nlink <= 2)      /* Empty directory */
                return 0;

        return 1;
}


So this looks like it became a part of ABI we cannot break...

A revert of this commit on the top of today's -next fixes the problem.

thanks,
-- 
js
suse labs
