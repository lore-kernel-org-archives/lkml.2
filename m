Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1DLTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1DLTJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:09:57 -0400
Date: Tue, 12 Apr 2011 15:09:34 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110412190934.GA12082@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 05:40:11PM -0700, Linus Torvalds wrote:
 > It's been another almost spookily calm week. Usually this kind of
 > calmness happens much later in the -rc series (during -rc7 or -rc8,
 > say), but I'm not going to complain. I'm just still waiting for the
 > other shoe to drop.
 
Here's an odd one.

my laptop's fstab has

/dev/mapper/vg_adamo-lv_home /home                   ext4    defaults        1 2

on 2.6.38, /proc/mounts contains ..

/dev/mapper/vg_adamo-lv_home /home ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0

on 2.6.39rc3 it looks like..

/dev/mapper/vg_adamo-lv_home /home ext4 rw,seclabel,relatime,user_xattr,barrier=1,data=ordered 0 0


Which looks like ea6633369458992241599c9d9ebadffaeddec164, so nothing untoward..

however, the output of mount looks very confused..

.38:
/dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)

.39:
- on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)

It looks like /proc/self/mountinfo broke abi.

.38:
48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered

.39:
46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered



	Dave

