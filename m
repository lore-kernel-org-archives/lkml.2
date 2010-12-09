Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0LITtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:49:35 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28076 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0LITte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:49:34 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=37qdrPIVUooonMxFi2BWZ8DhoCRe+hJcgJuumZcJ4K8= c=1 sm=1
 a=dDnec7dcvLMA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=O8kNqaAZklKQdHa2aVsA:9
 a=y4dDsylUVGt-YpwKbD2mTpC4p9oA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101209192050.GA26457@suse.de>
Date: Thu, 9 Dec 2010 12:49:32 -0700
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
        hch@infradead.org, axboe@kernel.dk
Content-Transfer-Encoding: 8BIT
Message-Id: <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com> <20101209192050.GA26457@suse.de>
To: Greg KH <gregkh@suse.de>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-09, at 12:20, Greg KH wrote:
> On Thu, Dec 09, 2010 at 04:25:35PM +0100, Lukas Czerner wrote:
>> For a long time it has been pretty painful to retrieve informations from
>> /sys/block/*/queue for particular block device. Not only it is painful
>> to retrieve informations within C tool, parsing strings, etc, but one
>> have to run into problem even finding the proper path in sysfs.
> 
> What's wrong with using libudev?  That should give you all of this
> information easily using a .c program without any need to change the
> kernel at all.
> 
> Ick, no, please just use the sysfs files, don't create a new ioctl, they
> are horrid.

Can you please show a real example of how using libudev is less horrid than just calling "ioctl(fd, BLKGETQUEUEINFO, &val)"?

How is trying to map a block device name from /etc/mtab (via getmntent()) into a possibly wildly different block device name in /sys (e.g. /dev/vgroot/lvhome vs. /dev/dm-0 vs. /dev/mapper/vgroot-lvhome => /sys/block/dm-0), then parsing text output considered a "good API"?

Cheers, Andreas





