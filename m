Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1EHRSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 13:18:37 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:48599 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1EHRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 13:18:34 -0400
Message-ID: <4DC6D067.1080208@hardwarefreak.com>
Date: Sun, 08 May 2011 12:18:31 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: 2.6.38.4: xfs speed problem?
References: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan> <20110508003321.GI26837@dastard>
In-Reply-To: <20110508003321.GI26837@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2011 7:33 PM, Dave Chinner wrote:
> On Sat, May 07, 2011 at 12:09:46PM -0400, Justin Piszcz wrote:
>> Hello,
>>
>> Using 2.6.38.4 on two hosts:
>>
>> Host 1:
>> $ /usr/bin/time find geocities.data 1>  /dev/null
>> 80.92user 417.93system 2:19:07elapsed 5%CPU (0avgtext+0avgdata 105520maxresident)k
>> 0inputs+0outputs (0major+73373minor)pagefaults 0swaps
>>
>> # xfs_db -c frag -f /dev/sda1
>> actual 40203982, ideal 40088075, fragmentation factor 0.29%
>>
>> meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=11718704640, imaxpct=5
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> --
>>
>> Host 2:
>> $ /usr/bin/time find geocities.data 1>/dev/null
>> 54.60user 337.20system 48:42.71elapsed 13%CPU (0avgtext+0avgdata 105632maxresident)k
>> 0inputs+0outputs (1major+72981minor)pagefaults 0swaps
>>
>> # xfs_db -c frag -f /dev/sdb1
>> actual 37998306, ideal 37939331, fragmentation factor 0.16%
>>
>> meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=2441379328, imaxpct=5
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0


How much would it help, if any, with this specific 'test', or with 
overall XFS performance, if Justin were to...

>> Host 1: RAID-6 (7200 RPM Drives, 18+1 hot spare)

remake the fs on the above device with 'sw=16' or remount with 
appropriate sunit and swidth values?

>> Host 2: RAID-6 (7200 RPM Drives, 12)

remake the fs on the above device with 'sw=10' or remount with 
appropriate sunit and swidth values?

-- 
Stan

