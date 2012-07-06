Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab2GFPvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:51:04 -0400
Received: from mail.bananateam.nl ([213.125.76.250]:51172 "EHLO
	mail.bananateam.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2GFPvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:51:02 -0400
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 11:51:02 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Jul 2012 17:40:18 +0200
From: Ferry <iscsitmp@bananateam.nl>
To: <linux-kernel@vger.kernel.org>
Subject: LIO - mdadm partitions as backend
Reply-To: <iscsitmp@bananateam.nl>
Mail-Reply-To: <iscsitmp@bananateam.nl>
Message-ID: <53c69b509b1d4b8bd9c2d52da73feb35@mail.bananateam.nl>
User-Agent: RoundCube Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

first off - sorry to bug you guys, relative simple issue - 
http://linux-iscsi.org/wiki/Support <- states to come here.

Anyways, walking my first steps with LIO, moving away from IET and 
running into an issue.

Rather than have several MD devices created out of partitions, we did 
the reverse. Added entire disks to MD and partitioned the MD set, 
resulting in device like /dev/md4p1, /dev/md4p2, etc.

Whilst these are block devices (afaik, seem to act that way everywhere 
else), targetcli doesn't seem to recognize them. At least not on the 
Ubuntu 12.04 server I'm trying it with, frequently giving not so savvy 
errors:

/backstores/fileio> create tt /dev/md4p1
For fileio, you must either specify both a file and a size, or just a 
device path.

Can't create it, did specify a path (more accurate error would be nice)

/backstores/fileio> create tt /dev/md4
Generating a wwn serial.
Not using buffered mode.
Created fileio tt with size None.
Entering new node /backstores/fileio/tt
No such path /backstores/fileio/tt

Creates it, but does give a no such path error, can cd into it and get 
status just fine....

/backstores/fileio> ls
o- fileio ................................................... [1 
Storage Object]
   o- tt ................................................. [/dev/md4 
deactivated]
/backstores/fileio> cd tt
/backstores/fileio/tt> ls
o- tt ................................................... [/dev/md4 
deactivated]
/backstores/fileio/tt> status
Status for /backstores/fileio/tt: /dev/md4 deactivated
/backstores/fileio/tt> cd ..

/backstores/fileio> delete tt
Deleted storage object tt.

Deletes fine.

/backstores/fileio> cd ../iblock
/backstores/iblock> create tt /dev/md4p1
Generating a wwn serial.
Device is not a TYPE_DISK block device.

Same issue here as blockio.

/backstores/iblock> create tt /dev/md4
Generating a wwn serial.
Created iblock storage object tt using /dev/md4.
Entering new node /backstores/iblock/tt
No such path /backstores/iblock/tt

Just like fileio creates it, but states no such path... Again can CD 
into it and get status tho'.

/backstores/iblock> cd tt
/backstores/iblock/tt> status
Status for /backstores/iblock/tt: /dev/md4 deactivated
/backstores/iblock/tt> cd ..
/backstores/iblock> delete tt
Deleted storage object tt.

Thanks in advance :).
