Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422970Ab2KNOAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:00:48 -0500
Received: from rrzmta5.uni-regensburg.de ([194.94.155.56]:52950 "EHLO
	rrzmta5.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2KNOAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:00:46 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2012 09:00:46 EST
Message-Id: <50A3B0A6020000A10000D757@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 14 Nov 2012 14:54:30 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: using cgroups in real life
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a question on cgroups (as of Linux 3.0):
The concept is to mount a filesystem, and configure cgroups through it. This implies that all the files belong to root (or maybe some other fixed user).

AFAIK, you can chmod() and chown() files, but these bits are only kept in the i-node cache, so they may change at any time.

I think this is bad, because if you want to allow users to limit (maybe memory usage) by using some predefined cgroup, the user needs at least partial write access to that cgroup (to add the PID). Probably this also means the user could add any PID (even those processes not owned by him).

The alternative is that a privileged task manages cgroups and PIDs. This is difficult, for example, if the process to control does not exist yet (e.g. the user logs in and then starts some process). It's getting tricky if the user maybe runs some big fat database (which should work at peak performance), and later logs in to do a backup of the database (which is not time critical, and should not steal all the I/O bandwidth). I wonder how a solution would look like to allow the user to limit the bandwidth (maybe use of page cache, too) of the backup in an reliable way.

Being paranoid, the user should at most be able to limit his own processes. I cannot envision a proper solution with the current interface.

Would anybody share some good ideas with me?

(I'm not subscribed to the kernel list, so please CC:)

Regards,
Ulrich



