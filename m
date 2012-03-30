Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548Ab2C3JuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:50:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41744 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2C3Jt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:49:59 -0400
X-IronPort-AV: E=Sophos;i="4.75,343,1330876800"; 
   d="scan'208";a="4658115"
Message-ID: <4F7581D4.4040301@cn.fujitsu.com>
Date: Fri, 30 Mar 2012 17:50:12 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: [PATCH 0/4] block: move sd_format_disk_name() into block core as
 disk_name_format()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:47:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:47:41,
	Serialize complete at 2012-03-30 17:47:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch series renames "sd_format_disk_name()" to
"disk_name_format()" and moves it into block core. So
that who needs formatting disk name can use it, instead
of duplicating these similar help functions.

Ren Mingxin (4):
   block: add function disk_name_format() into block core
   scsi: replace sd_format_disk_name() to disk_name_format()
   block: replace rssd_disk_name_format() to disk_name_format()
   virtio_blk: use disk_name_format() to support mass of disks naming

  block/genhd.c                     |   49 ++++++++++++++++++++++++++++++++++++++
  drivers/block/mtip32xx/mtip32xx.c |   33 -------------------------
  drivers/block/virtio_blk.c        |   13 ----------
  drivers/scsi/sd.c                 |   48 -------------------------------------
  include/linux/genhd.h             |    2 +
  5 files changed, 54 insertions(+), 91 deletions(-)

Any comment will be appreciated.

Thanks,
Ren


