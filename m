Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1BOQ67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab1BOQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:58:56 -0500
Message-ID: <4D5AB0C5.9030304@redhat.com>
Date: Tue, 15 Feb 2011 17:58:45 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alasdair G Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device read-write
 for read-only mappings
References: <4D5A6EF4.3030905@redhat.com> <20110215124629.GF5825@agk-dp.fab.redhat.com> <20110215152033.GK3160@htj.dyndns.org> <20110215154625.GG5825@agk-dp.fab.redhat.com> <20110215155018.GM3160@htj.dyndns.org> <4D5AA45C.7050600@redhat.com> <20110215161228.GN3160@htj.dyndns.org> <4D5AAB8F.50901@redhat.com> <20110215164128.GQ3160@htj.dyndns.org>
In-Reply-To: <20110215164128.GQ3160@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/15/2011 05:41 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Feb 15, 2011 at 05:36:31PM +0100, Milan Broz wrote:
>> Well, I am also not sure about that.
>>
>> But the problem is that read-write open fails now while it worked before.
>> (TBH I have no idea when that EROFS fallback worked - because the code
>> opened device RW, issued EROGET ioctl and set read-only... for years.)
>>
>> Anyway I think EROFS is used on block devices, just grep kernel source.
> 
> Ah, okay, so the fallback was there just in case.  It didn't really
> trigger and right it wouldn't have triggered until now, so your
> assertion about how many programs would break is kinda bogus.  You
> just have single isolated case which hasn't been excercised till now.
> There may as well be code pieces which check against EACCES or what
> not.

If you want another example, here is MD one.

# blockdev --setrw /dev/sd[bcde]
# mdadm -A /dev/md0 /dev/sd[bcde]
mdadm: /dev/md0 has been started with 4 drives.
# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# blockdev --setro /dev/sd[bcde]
# mdadm -A /dev/md0 /dev/sd[bcde]
mdadm: cannot re-read metadata from /dev/sdb - aborting

Works on 2.6.36.

Thanks,
Milan
