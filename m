Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab0KROie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:38:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54627 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab0KROic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:38:32 -0500
Message-ID: <4CE539E8.2040107@oracle.com>
Date: Thu, 18 Nov 2010 22:36:24 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118143101.GO5618@dhcp231-156.rdu.redhat.com>
In-Reply-To: <20101118143101.GO5618@dhcp231-156.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/18/2010 10:31 PM, Josef Bacik wrote:
> On Thu, Nov 18, 2010 at 07:19:58AM -0700, Matthew Wilcox wrote:
>> On Thu, Nov 18, 2010 at 08:48:04AM -0500, Josef Bacik wrote:
>>> On Thu, Nov 18, 2010 at 06:06:30AM -0700, Matthew Wilcox wrote:
>>>> On Thu, Nov 18, 2010 at 08:36:48AM +0100, Lukas Czerner wrote:
>>>>> There was concern that FITRIM ioctl is not common enough to be included
>>>>> in core vfs ioctl, as Christoph Hellwig pointed out there's no real point
>>>>> in dispatching this out to a separate vector instead of just through
>>>>> ->ioctl.
>>>>
>>>> Um, are you and Josef working independently of each other?  You don't
>>>> seem to be cc'ing each other on your patches, and you're basically doing
>>>> the same thing.
>>>>
>>>
>>> I guess they are the same thing in that we're both dealing with free'ing up
>>> space, but thats about where the similarities end.  Lukas' work is in TRIM'ing
>>> already free'd space, mine is in creating free'd space.  Plus I don't know
>>> anything nor wish to ever know anything about TRIM ;).  Thanks,
>>
>> I guess I was assuming that, on receiving a FALLOC_FL_PUNCH_HOLE, a
>> filesystem that was TRIM-aware would pass that information down to the
>> block device that it's mounted on.  I strongly feel that we shouldn't
>> have two interfaces to do essentially the same thing.
>
> But they aren't doing the same thing, his is discarding already free'd space,
> I'm enabling people to de-allocate space in the middle of files, they are two
> seperate things.  Of course if the filesystem is TRIM aware the de-allocation
> would lead to a TRIM, but not if the filesystem isn't mounted with -o discard.
> Hole punching is useful independantly of the ability to do TRIM.  Thanks,
yeah, actually, ocfs2 has implemented punching holes while we don't have 
TRIM support enabled yet.

Regards,
Tao
