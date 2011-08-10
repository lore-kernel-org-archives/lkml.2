Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1HJJve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:51:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44976 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1HJJvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:51:33 -0400
Message-ID: <4E42537A.6000408@gmail.com>
Date: Wed, 10 Aug 2011 15:16:34 +0530
From: Mayank Rungta <mr.mynk@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        yakui.zhao@intel.com, "A.R Karthick" <a.r.karthick@gmail.com>,
        karthick.linuxdreamer@gmail.com
Subject: Re: [PATCH 2.6.38-10-generic] device driver: fix oops in radeon driver
 due to incorrect value from hardware
References: <4E417AF8.7090202@gmail.com> <1312968271.14630.189.camel@thor.local>
In-Reply-To: <1312968271.14630.189.camel@thor.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/10/2011 02:54 PM, Michel Dänzer wrote:

> On Die, 2011-08-09 at 23:52 +0530, Mayank Rungta wrote:
>> Added a check for the radeon ring buffer write index in r600.c which
>> reads 0xffffffff on resume. This results in an Oops during
>> radeon_ring_write. Masking the value averts this.
>>
>> This problem is not seen to be fixed in 3.0 r600.c as well.
>>
>> Detailed analysis of the problem can be found at -
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/
>>
>> ---
>>
>> BUG: unable to handle kernel paging request at fa501ffc - Oops at
>> r600_cp_start+0x48/0x380 in r600_cp_resume+0x345/0x580 [radeon]
>>
>> drivers/gpu/drm/radeon/r600.c
>>
>>
>>
>> --- linux-2.6.38/drivers/gpu/drm/radeon/r600.c.orig    2011-08-05
>> 15:39:40.824612700 +0530
>> +++ linux-2.6.38/drivers/gpu/drm/radeon/r600.c    2011-08-08
>> 05:29:21.744417857 +0530
>> @@ -2218,6 +2218,8 @@ int r600_cp_resume(struct radeon_device
>>
>>        rdev->cp.rptr = RREG32(CP_RB_RPTR);
>>        rdev->cp.wptr = RREG32(CP_RB_WPTR);
>> +    /* protect against crazy HW on resume */
>> +    rdev->cp.wptr&= rdev->cp.ptr_mask;
>
> The indentation of the lines you're adding doesn't match the surrounding
> lines.
Sorry. This looked fine in the mail I sent. I shall be careful in future.

>
>
> Although the same workaround is already in r100.c, I wonder if we
> shouldn't rather try and eliminate all reads from the CP_RB_WPTR
> register, at least other than for debugging purposes. Alex, what do you
> think?
>
> Otherwise, this should probably be added in evergreen.c as well.
>
>
>>           Developer's Certificate of Origin 1.1
>>
>>           [...]
>
> No need to include all this text, just the *-by: tags are enough.
>
Point taken.

