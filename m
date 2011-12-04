Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1LDQFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:05:03 -0500
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3792 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1LDQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:05:01 -0500
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Dec 2011 11:05:01 EST
Date: Sun, 4 Dec 2011 16:58:01 +0100
Message-Id: <201112041558.pB4Fw1tn002287@xs8.xs4all.nl>
From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
To: daniel.lezcano@free.fr
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][v2] Add reboot_pid_ns to handle the reboot syscall
X-Newsgroups: lists.linux.kernel
In-Reply-To: <1322956280-13831-2-git-send-email-daniel.lezcano@free.fr>
References: <1322956280-13831-1-git-send-email-daniel.lezcano@free.fr>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <xs4all.1322956280-13831-2-git-send-email-daniel.lezcano@free.fr> you write:
>This patch propose to store the reboot value in the 16 upper bits of the
>exit code from the processes belonging to a pid namespace which has
>rebooted. When the reboot syscall is called and we are not in the initial
>pid namespace, we kill the pid namespace.

Should there be a way to find out if the reboot systemcall is
containerized or not (other than comparing kernel versions once
this is mainlined) ?

For example, a tool like lxc-start might want to disable CAP_SYS_REBOOT
if the reboot system call is not containerized.

Perhaps a LINUX_REBOOT_CMD_ISCONTAINER (or ISVIRTUAL, whatever,
bikeshed away) should be added that simply returns 0 if sys_reboot
is containerized. It would return -EINVAL as it does today if it's not.

Thoughts ?

Mike.
