Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1C1IKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:10:15 -0400
Received: from lucidpixels.com ([75.144.35.66]:46123 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1C1IKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:10:13 -0400
Date: Mon, 28 Mar 2011 04:10:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.38.1: CPU#0 stuck for 67s! / xfs_ail_splice
In-Reply-To: <20110327232543.GU26611@dastard>
Message-ID: <alpine.DEB.2.02.1103280406300.25113@p34.internal.lan>
References: <alpine.DEB.2.02.1103260927500.21571@p34.internal.lan> <20110327232543.GU26611@dastard>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Mar 2011, Dave Chinner wrote:

> On Sat, Mar 26, 2011 at 09:29:36AM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> When I rm -rf a directory of a few hundred thousand
>> files/directories on XFS under 2.6.38.1, I see the following, is
>> this normal?
>
> No. What is you filesystem config (xfs_info) and your mount options?
> Is it repeatable? I? the system otherwise stalled or is it still
> operating normally? Does it recover and work normally after such a
> stall?

Hi Dave, default mkfs.xfs options:

> What is you filesystem config (xfs_info) and your mount options?

# xfs_info /dev/sda1
meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=11718704640, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

/dev/sda1 on /r1 type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144,delaylog,inode64)

> Is it repeatable?
I've not tried to repeat it as is spews messages over all of my consoles but
it has happened more than once.

> the system otherwise stalled or is it still operating normally?
The console/xterm/ssh etc that is performing the removal does lockup but
you are able to access the machine via a separate ssh connection.

> Does it recover and work normally after such a stall?
Yes, eventually, I believe I started seeing this problem when I added
'delaylog' option to the mount options..

Justin.

