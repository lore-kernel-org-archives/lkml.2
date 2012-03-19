Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2CSTiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:38:14 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:39758 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab2CSTiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:38:13 -0400
Date: Mon, 19 Mar 2012 19:38:04 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Shaohua Li <shli@fusionio.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
In-Reply-To: <20120316073213.656519005@fusionio.com>
Message-ID: <alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
References: <20120316073213.656519005@fusionio.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 16 Mar 2012, Shaohua Li wrote:

> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM support for
> raid 4/5/6 later. The implementation is pretty straightforward and
> self-explained.
>
> v1->v2:
> 1. fixed a checking issue
> 2. dropped discard request plug and replace it with no discard merege, because
> current SCSI layer can't handle discard request merge.
>
Have tested TRIM patches on three different systems with the following
hardware/ setup:

    1) root mounted on a raid1 over two SAS SSD's (200GB) and /home partition
       on a raid0 over a fusionio ioDrive Duo. Is very new and seen very
       little usage.

    2) root and /home mounted on a raid0 over two Intel X25 Postville
       (160GB) connected to a Intel P55 Express chipset. Has seen very
       heavy usage for approx. 2 years.

    3) root and /home mounted on a raid0 over three OCZ-VERTEX2 (120GB)
       connected via ICH7 south bridge. Has seen mild usage for approx.
       1.5 years.

Made the following observations when running my own benchmark which
copies around a lot of small files and deletes them. The benchmark on
all systems was always run only on the /home partition ie. on a raid0.

For system 1) there is hardly any measurable differnce whether discard
is enabled or not (~29000 files per second).

On system 2) the performance drops from 6500->3700 files per second,
but under normal usage one does not notice any difference.

System 3) has problems during boot, it is so slow that some operations
receive a timeout during boot:

   udevd[474]: timeout '/sbin/blkid -o udev -p /dev/md0'
   udevd[474]: timeout: killing '/sbin/blkid -o udev -p /dev/md0' [866]
   systemd[1]: dev-md3.swap activation timed out. Stopping.

Even removing discard does not help and the above errors happen during
boot and booting takes a long time.

The performance in the benchmark drops from 4000->600 files per second.

Regards,
Holger
