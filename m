Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1COMfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:35:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36751 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab1COMfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:35:12 -0400
Message-ID: <4D7F5CFE.8000200@kernel.dk>
Date: Tue, 15 Mar 2011 13:35:10 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Anton Altaparmakov <aia21@cam.ac.uk>
CC: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Andreas_Bie=DFmann?= <biessmann@corscience.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in, __mark_inode_dirty
References: <fa.8ND6HoGS9dKYUuniFCAoNq+1TFY@ifi.uio.no> <4D78AA72.3060202@secunet.com> <4D7F3CD5.9030105@secunet.com> <99773600-FC41-41A9-8544-BF7E09065546@cam.ac.uk>
In-Reply-To: <99773600-FC41-41A9-8544-BF7E09065546@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-15 13:11, Anton Altaparmakov wrote:
> Hi,
> 
> On 15 Mar 2011, at 10:17, Torsten Hilbrich wrote:
>> On 10.03.2011 11:39, Torsten Hilbrich wrote:
>>> I ran into the same problem and successfully applied your fix.
>>>
>>> I was able to reproduce this panic and bisected it to the following commit:
>>>
>>> commit aaead25b954879e1a708ff2f3602f494c18d20b5
>>> Author: Christoph Hellwig <hch@lst.de>
>>> Date:   Mon Oct 4 14:25:33 2010 +0200
>>>
>>>    writeback: always use sb->s_bdi for writeback purposes
>>>
>>> The steps to reproduce it on my test system (T60p with Intel Core Duo) were.
>>
>> Added Christoph to CC. I also open a bug report at https://bugzilla.kernel.org/show_bug.cgi?id=31112
> 
> This is already being handled.  It is the same as other bug reports,
> i.e. the fact that sb->s_bdi is made NULL on device removal and if it
> happens at the wrong time you then get a NULL pointer dereference.
> 
> Jens Axboe just only yesterday posted an initial patch for this.  Can
> you please test it and report back if it does indeed cure the problem?
> 
> The patch can be found here for example:
> 
> 	https://lkml.org/lkml/2011/3/14/25

Yes, any testing of that patch would be greatly appreciated.

-- 
Jens Axboe

