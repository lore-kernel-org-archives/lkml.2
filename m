Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0E0NAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:00:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49004 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0E0NAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:00:53 -0400
Date: Thu, 27 May 2010 08:59:52 -0400
From: Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Message-ID: <20100527125952.GQ3108@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
 <1274461422-18433-6-git-send-email-josef@redhat.com>
 <4BFDE1CE.4030100@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFDE1CE.4030100@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BFE6CF6.01A6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:06:54AM +0800, liubo wrote:
> On 05/22/2010 01:03 AM, Josef Bacik wrote:
> > In order for AIO to work, we need to implement aio_write.  This patch converts
> > our btrfs_file_write to btrfs_aio_write.  I've tested this with xfstests and
> > nothing broke, and the AIO stuff magically started working.  Thanks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> >   
> 
> Hi, Josef,
> 
> I've tested your patch(May 22) with my tools, and one case triggered a bug
> which made writev operation hang up, more information is followed.
> 
> - Steps to trigger it:
>   # mount /dev/sda8 /home/btrfsdisk -o nodatacow
>   # gcc direct-io.c -o direct-io
>   # ./direct-io O_DIRECT writev /home/btrfsdisk/testrw 4M

Thanks for sending along this test program and bug report.  We've fixed
a few bugs in the O_DIRECT patches, and this is working now.

The merged result is in the for-linus branch of the btrfs unstable tree.

-chris
