Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0ITUTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:19:06 -0400
Received: from web113411.mail.gq1.yahoo.com ([98.136.167.31]:41328 "HELO
	web113411.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757192Ab0ITUTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:19:05 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2010 16:19:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=Lquj3GYhGgCFLEjs1xFto0foIQss7WFP3Z3vNNyB6Fp6KuFCpa1+2mcEnQ+xdnGSBUyK+6i9SOGqJW8o2t4NnIYYoaSsLXaoOl2uX2Z8B9Myicf6dVE6UBWP4zcY6frmmadz4NIV2cvToo/sJPqKikVX4Kx+WNhKQgagUDGZHfQ=;
Message-ID: <633175.66987.qm@web113411.mail.gq1.yahoo.com>
X-YMail-OSG: FM_Nu2kVM1n9Ic9NqPgGu9.eXRNQwTq7Uhgsv2LAjGtrQJc
 YyGvJungZknJIxEx2NAnqbtYJXKw3YLcJ1UpNtmaS3ZqqMithu7YTHFJ7ztv
 6M.xzw4odDKfJjBmd7OCn0uA0j8drWv.KFS5CZTReJZDJ5WisVAyOrn_WThn
 7QFZSAY2QKGXLaq4uv_1tZPCNJ6AveM53Ed2WkePGYaBt_RbAWhtpLnrBGtD
 XyjRYc032.6zfF9RWzRtwkSaLmeA4F4MN
X-Mailer: YahooMailRC/497 YahooMailWebService/0.8.105.279950
Date: Mon, 20 Sep 2010 13:12:22 -0700 (PDT)
From: Neeraj Kumar <neeraj.kumar01@ymail.com>
Subject: Doing a zero-copy move of data from a kernel buffer to hard disk
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to move data from a buffer in kernel space into the hard
disk without having to incur any additional copies from kernel buffer to
user buffers or any other kernel buffers. Any ideas/suggestions would be
most helpful.

The use case is basically a demux driver which collects data into a
demux buffer in kernel space and this buffer has to be emptied
periodically by copying the contents into a FUSE-based partition on the
disk. As the buffer gets full, a user process is signalled which then
determines the sector numbers on the disk the contents need to be copied
to.

I was hoping to mmap the above demux kernel buffer into user address
space and issue a write system call to the raw partition device. But
from what I can see, the this data is being cached by the kernel on its
way to the Hard Disk driver. And so I am assuming that involves
additional copies by the linux kernel.

At this point I am wondering if there is any other mechansim to do this
without involving additional copies by the kernel. I realize this is an
unsual usage scenario for non-embedded environments, but I would
appreciate any feedback on possible options.

BTW - I have tried using O_DIRECT when opening the raw partition, but
the subsequent write call fails if the buffer being passed is the
mmapped buffer.


Thanx!



      
