Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1DLHxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:53:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39052 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1DLHxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ng/zK0pewgLYBOH5ntB037fxl0uVyqRkBU0m7LAJb0mRjf5dJoS1cPQtsoB1yktzMh
         qRS4uTYJ9uLHtcVG1+yub/sF2R1DoNkG5BnrgCH0ZjO29WqvG86ZeU9IOLTtJ0GyPe+1
         747HQPh/pNld7RtAwXJ0+sFg8sAHtDdhg7ViM=
Subject: Huge XFS regression in 2.6.32 upto 2.6.38
From: raz ben yehuda <raziebe@gmail.com>
To: hch@lst.de
Cc: linux-kernel@vger.kernel.org, felixb@sgi.com, dgc@sgi.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 10:52:28 +0300
Message-ID: <1302594748.2750.11.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hello
I am testing 2.6.38 with AIM benchmark. 
I compared 2.6.38 to 2.6.27 and I noticed that 2.6.27 is much better than 2.6.38 when 
doing sync random writes test over an xfs regular file over native Linux partition on top common sata disk.
I git bisected the problem and I reached this SHA1:
commit 13e6d5cdde0e785aa943810f08b801cadd0935df
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Aug 31 21:00:31 2009 -0300

    xfs: merge fsync and O_SYNC handling

    The guarantees for O_SYNC are exactly the same as the ones we need to
    make for an fsync call (and given that Linux O_SYNC is O_DSYNC the
    equivalent is fdadatasync, but we treat both the same in XFS), except
    with a range data writeout.  Jan Kara has started unifying these two
    path for filesystems using the generic helpers, and I've started to
    look at XFS.
...


The bellow two tests presents the how different performance is before and patch:
#test 16) bisect 11
------------------------------------------------------------------------------------------------------------
 Test        Test        Elapsed  Iteration    Iteration          Operation
Number       Name      Time (sec)   Count   Rate (loops/sec)    Rate (ops/sec)
------------------------------------------------------------------------------------------------------------
     1 sync_disk_rw        30.71         19    0.61869         1583.85 Sync Random Disk Writes (K)/second
------------------------------------------------------------------------------------------------------------

#test 17 ) bisect 12
------------------------------------------------------------------------------------------------------------
     1 sync_disk_rw        69.05          1    0.01448           37.07 Sync Random Disk Writes (K)/second
------------------------------------------------------------------------------------------------------------


Regards
Raz Ben-Yehuda


