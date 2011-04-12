Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1DLU1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127Ab1DLU1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:27:31 -0400
Date: Tue, 12 Apr 2011 22:27:19 +0200
From: Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110412202719.GM6764@nb.net.home>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412190934.GA12082@redhat.com> <4DA4B3FE.2080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA4B3FE.2080609@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 03:20:14PM -0500, Eric Sandeen wrote:
> > It looks like /proc/self/mountinfo broke abi.
> > 
> > .38:
> > 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
> > 
> > .39:
> > 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered
> > 
> 
> so it's supposed to be like this, from Documentation/filesystems/proc.txt:
> 
> > This file contains lines of the form:
> > 
> > 36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 /dev/root rw,errors=continue
> > (1)(2)(3)   (4)   (5)      (6)      (7)   (8) (9)   (10)         (11)
> > 
> > (1) mount ID:  unique identifier of the mount (may be reused after umount)
> > (2) parent ID:  ID of parent (or of self for the top of the mount tree)
> > (3) major:minor:  value of st_dev for files on filesystem
> > (4) root:  root of the mount within the filesystem
> > (5) mount point:  mount point relative to the process's root
> > (6) mount options:  per mount options
> > (7) optional fields:  zero or more fields of the form "tag[:value]"
> > (8) separator:  marks the end of the optional fields
> > (9) filesystem type:  name of filesystem of the form "type[.subtype]"
> > (10) mount source:  filesystem specific information or "none"
> > (11) super options:  per super block options
> 
> it does seem that the new UUID info is in a perfectly fine place
> (the optional fields slot), at least per the docs, so I guess I
> might blame the mount binary for not following the aforementioned
> rules...

 Yes, I agree. Already discussed at lkml and linux-fs :-)
 http://thread.gmane.org/gmane.linux.kernel/1121533 

> Maybe Karel knows?  cc'd...

 Already fixed in util-linux upstream.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
