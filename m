Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1EZR65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:58:57 -0400
Received: from smtp-sjl2.savagebeast.com ([208.85.40.101]:56387 "EHLO
	smtp-sjl2.savagebeast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab1EZR64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:58:56 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 13:58:56 EDT
X-AuditID: 0a0a5020-b7c9bae000000b2d-5e-4dde915b017f
Message-ID: <4DDE916E.3070803@pandora.com>
Date: Thu, 26 May 2011 10:44:14 -0700
From: Dave Rawks <dave@pandora.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: inconsistent behavior of MS_RELATIME F_FLAG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I've been trying to figure this out for the past few days and I'm at a
loss as to what exactly the expected behavior of the MS_RELATIME bit in
F_FLAG is supposed to reflect when I stat a mounted filesystem. The
comments in fs.h state that the MS_RELATIME flag is one of the
filesystem independent flags available in the regular 32 bit F_FLAG
mask. However observationally I notice that /proc/mounts indicates that
relatime is set even on mount which return 0 for the relatime bit when
stat'd.

For instance:

/etc/fstab:
>/dev/sda3 /var            ext3    defaults        0       2

/proc/mounts:
> /dev/sda3 /var ext3 rw,relatime,errors=continue,data=ordered 0 0

yet when I stat the filesystem (excuse my python):

> >>> import os,statvfs
> >>> os.statvfs('/var')[statvfs.F_FLAG]
> 4096
> >>> 4096 & (1<<21)
> 0


>From a quick search back through the list archive, I see that the
default atime behavior has been a contentious subject at times, but I'm
left wondering how we came to a state where apparently relatime is the
default but the normal programmatic way of interrogating the mount's
state does not reflect that.

Any insight would be greatly appreciated. Also, this is my first post to
lkml so I apologize in advance if I've asked in the wrong place.

-Dave Rawks
