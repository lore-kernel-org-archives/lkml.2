Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2BQNfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:35:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:20677 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2BQNfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:35:09 -0500
Date: Fri, 17 Feb 2012 08:34:56 -0500
From: Chris Mason <chris.mason@oracle.com>
To: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-fsdevel@vger.kernel.org
Subject: Re: Kernel bug with btrfs on laptop with external hd and suspend and
 resume.
Message-ID: <20120217133456.GG21896@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	"Nathan A. Mourey II" <nmoureyii@ne.rr.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Linux PM mailing list <linux-pm@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-fsdevel@vger.kernel.org
References: <1328990690.2464.6.camel@firefly>
 <4F391B83.7080703@linux.vnet.ibm.com>
 <20120213144107.GC1573@shiny>
 <1329428930.6062.4.camel@firefly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329428930.6062.4.camel@firefly>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F3E5785.0174,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 04:48:50PM -0500, Nathan A. Mourey II wrote:
> I booted up my laptop with my eSATA drives attached and mounted.  I then
> closed the lid without logging in.  It then when to sleep mode.  I was
> wrong in my first post about the computer suspending.  It didn't suspend
> to disk, as I would have noticed the hd light.  The drives where not
> unplugged at any time.  It looks like the problem occurred when trying
> to stop the disks.  I was able to do a hard reboot and the disk came up
> fine.  Once again I hope that this helps.
> 
> 
> Feb 14 14:46:39 firefly kernel: [   96.374559] Restarting tasks ...
> Feb 14 14:46:39 firefly kernel: [   96.375986] XFS (sdb1): xfs_do_force_shutdown(0x1) called from line 1033 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffa05f18ba
> Feb 14 14:46:39 firefly kernel: [   96.375993] XFS (sdb1): I/O Error Detected. Shutting down filesystem
> Feb 14 14:46:39 firefly kernel: [   96.376017] XFS (sdb1): Please umount the filesystem and rectify the problem(s)
> Feb 14 14:46:39 firefly kernel: [   96.384244] sd 4:0:0:0: [sdb] Synchronizing SCSI cache
> Feb 14 14:46:39 firefly kernel: [   96.384280] sd 4:0:0:0: [sdb]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb 14 14:46:39 firefly kernel: [   96.384284] sd 4:0:0:0: [sdb] Stopping disk
> Feb 14 14:46:39 firefly kernel: [   96.384291] sd 4:0:0:0: [sdb] START_STOP FAILED
> Feb 14 14:46:39 firefly kernel: [   96.384293] sd 4:0:0:0: [sdb]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

These messages look like the drive wasn't up and running when the
filesystem tried to talk with it.  Both XFS and btrfs are having trouble
(some more gracefully than others) so this should be a problem in the
resume code.

-chris
