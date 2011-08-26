Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1HZXF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:05:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64914 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1HZXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1108261844170.2203@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
	<20110818130408.71c55b96@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
	<CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
	<alpine.DEB.2.02.1108181331180.7903@p34.internal.lan>
	<CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com>
	<alpine.DEB.2.02.1108181413030.7903@p34.internal.lan>
	<20110818145257.035a38e9@barsoom.rdu.redhat.com>
	<20110826175940.2830044d@tlielax.poochiereds.net>
	<alpine.DEB.2.02.1108261844170.2203@p34.internal.lan>
Date: Fri, 26 Aug 2011 18:05:55 -0500
Message-ID: <CAH2r5mtrUq4aTHgqRyG-YZZoUztU4_k4rh+nXrN13CVckex8ZQ@mail.gmail.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
From: Steve French <smfrench@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Layton <jlayton@samba.org>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 5:57 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Fri, 26 Aug 2011, Jeff Layton wrote:
>
>> On Thu, 18 Aug 2011 14:52:57 -0400
>> Jeff Layton <jlayton@samba.org> wrote:
>>
>>> On Thu, 18 Aug 2011 14:18:15 -0400 (EDT)
>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>
>>>>
>>> Like I said, read performance with cifs.ko just plain sucks currently.
>>>
>>> Don't look for cifs.ko to achieve anywhere near NFS' performance unless
>>> you jump through some very odd hoops (like multithreading your workload
>>> in userspace, etc). cifs.ko just doesn't do a good job of keeping the
>>> pipe "stuffed" as most calls are handled synchronously. A single task
>>> can only handle one call on the wire in most cases. The exception here
>>> is writes, but that just recently changed...
>>>
>>> Reads are done using relatively small buffers and then copied to
>>> pagecache. Part of what I'm working on will be to allow for much larger
>>> reads directly into the pagecache. That should also help performance
>>> significantly.
>>>
>>
>> I just posted a patchset that should improve the performance of
>> buffered reads. It's rather large but should apply to current upstream
>> kernels. If you've had problems with cifs.ko read performance in the
>> past, then this would be a good time to step up and help test them.
>>
>> If it makes things easier, then the patchset is also available via the
>> cifs-3.2 branch of my public git tree:
>>
>>
>> http://git.kernel.org/?p=linux/kernel/git/jlayton/linux.git;a=shortlog;h=refs/heads/cifs-3.2
>>
>> Thanks,
>> --
>> Jeff Layton <jlayton@samba.org>
>
> Hi Jeff,
>
> This was working earlier..
>
> # mount -t cifs //10.0.1.1/x /mnt -o user=XXXXXXX,pass=XXXXXXXX
> mount error(12): Cannot allocate memory
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> I'll need to contact the owner of the host to see if something has changed
> as this _was_ working previously.

Fails with Jeff's new 20+ patch series?


-- 
Thanks,

Steve
