Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0FQGFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:05:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43043 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab0FQGFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=nR8FdcLHez14ZydmzQJw6UqDHOrBCwllp6jJxckZxcqcewoTaGvebQvlFTr9o4+T0X
         VuDwwG63VePQ73eN+qorSYVJYT0TtXNT+fh2g0soL841IgVA5r2RIaGpNRTL0Q7FPpoa
         HCSOG1IdI1JF1lGr4OOevzJnr3Z+4Rzay+oqM=
Date: Thu, 17 Jun 2010 14:05:32 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       Greg KH <greg@kroah.com>, kristen.c.accardi@intel.com,
       Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Wilcox <willy@hp.com>
Subject: What is HSM violation? Causing ata1.00 hard resetting link
Message-ID: <Pine.LNX.4.64.1006171341420.8191@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I just got an external e-SATA hard disk, and I'm testing for backup.

When I tried to "tar" 90GB to it, it caused a HSM violation, and since 
this
is the root file system, system is brain-dead. "Bus error" for every 
command
issued!


Error is (typed as was captured in the screen) ...

ata1.00: exception Emask 0x2 SAct 0x7 SErr 0x3000400 action 0x6
ata1.00: irq_stat 0x44000008
ata1.00: cmd 60/30:00:37:b0:84/00:00:17:00:00/40 tag 0 ncq 24576 in
        res 40/00:08:6f:b0:84/00:00:17:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/50:08:6f:b0:84/00:00:17:00:00/40 tag 1 ncq 40960 in
        res 51/04:00:6f:b0:84/00:00:17:00:00/40 Emask 0x403 (HSM violation)
ata1.00: cmd 60/00:10:bf:b0:84/01:00:17:00:00/40 tag 2 ncq 131072 in
        res 40/00:08:6f:b0:84/00:00:17:00:00/40 Emask 0x2 (HSM violation)
ata1: hard resetting link
ata1: softreset failed (device not ready)
ata1: hard resetting link
ata1: softreset failed (device not ready)
ata1: hard resetting link
ata1: link is slow to respond, please be patient (ready=0)


Running on SSD on Linux 2.6.35-rc3.

This does not happen all the time, but I've seen this if it's copying
intensively.

Thanks,
Jeff.
