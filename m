Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0IHOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:25:28 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56698 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0IHOZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:25:27 -0400
Message-ID: <4C879CCF.5080703@kernel.dk>
Date: Wed, 08 Sep 2010 16:25:19 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: fuse-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ionice and FUSE-based filesystems?
References: <4C800B06.90005@genband.com> <4C814514.4040103@kernel.dk> <4C814B8D.7050100@genband.com>
In-Reply-To: <4C814B8D.7050100@genband.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-03 21:25, Chris Friesen wrote:
> On 09/03/2010 12:57 PM, Jens Axboe wrote:
>> On 09/02/2010 10:37 PM, Chris Friesen wrote:
>>>
>>> I'm curious about the limits of using ionice with multiple layers of
>>> filesystems and devices.
>>>
>>> In particular, we have a scenario with a FUSE-based filesystem running
>>> on top of xfs on top of LVM, on top of software RAID, on top of spinning
>>> disks.  (Something like that, anyways.)  The IO scheduler is CFQ.
>>>
>>> In the above scenario would you expect the IO nice value of the writes
>>> done by a task to be propagated all the way down to the disk writes?  Or
>>> would they get stripped off at some point?
>>
>> Miklos should be able to expand on what fuse does, but at least on
>> the write side priorities will only be carried through for non-buffered
>> writes with the current design (since actual write out happens out of
>> context of the submitting application).
> 
> So we're talking either O_SYNC or O_DIRECT only?  That seems an
> unfortunate limitation given that it then forces the app to block.  Has
> any thought been given to somehow associating the priority with the
> actual operation so that it would affect buffered writes as well?

Yes. Work is progressing to allow to track dirty pages which would then
allow you to use ionice for buffered writes as well.

-- 
Jens Axboe

