Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0ICT0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 15:26:09 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:49408 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab0ICT0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 15:26:06 -0400
Message-ID: <4C814B8D.7050100@genband.com>
Date: Fri, 03 Sep 2010 13:25:01 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: fuse-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ionice and FUSE-based filesystems?
References: <4C800B06.90005@genband.com> <4C814514.4040103@kernel.dk>
In-Reply-To: <4C814514.4040103@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 19:25:03.0968 (UTC) FILETIME=[B5A5C600:01CB4B9D]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17614.001
X-TM-AS-Result: No--11.965100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 12:57 PM, Jens Axboe wrote:
> On 09/02/2010 10:37 PM, Chris Friesen wrote:
>>
>> I'm curious about the limits of using ionice with multiple layers of
>> filesystems and devices.
>>
>> In particular, we have a scenario with a FUSE-based filesystem running
>> on top of xfs on top of LVM, on top of software RAID, on top of spinning
>> disks.  (Something like that, anyways.)  The IO scheduler is CFQ.
>>
>> In the above scenario would you expect the IO nice value of the writes
>> done by a task to be propagated all the way down to the disk writes?  Or
>> would they get stripped off at some point?
> 
> Miklos should be able to expand on what fuse does, but at least on
> the write side priorities will only be carried through for non-buffered
> writes with the current design (since actual write out happens out of
> context of the submitting application).

So we're talking either O_SYNC or O_DIRECT only?  That seems an
unfortunate limitation given that it then forces the app to block.  Has
any thought been given to somehow associating the priority with the
actual operation so that it would affect buffered writes as well?

As for fuse...I was concerned that the addition of userspace tasks to
handle the filesystem operations would result in the I/O operations
taking on the priority of the fuse tasks rather than the originating
task.  Or does fuse adjust its I/O nice level according to that of the
incoming requests?

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
