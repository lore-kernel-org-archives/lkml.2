Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1HOSJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:09:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38706 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1HOSJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:09:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
Date: Mon, 15 Aug 2011 13:09:01 -0500
Message-ID: <CAH2r5mube6=0h_G=rvyWJs_ispNSmEQ3+zekazd6nKESs6FkvQ@mail.gmail.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS
From: Steve French <smfrench@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the more current cifs (ie  patches applied) does it fail on the
mount? or after the mount on the df -h that you mentioned in your
earlier note?

Not immediately obvious to me if the oops has much to do with cifs
code given the call stack, but we may be able to determine a little
more by looking at a wireshark trace of the last network request
and/or response (presumably parsing a cifs QFSInfo response from
Windows 7).

I also run Windows 7 64 server in our test environment, will rebuild
on laster 3.0.1-rc2 and retry but I would be surprised if I can
reproduce this.

On Mon, Aug 15, 2011 at 1:01 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Mon, 15 Aug 2011, Justin Piszcz wrote:
>
>>
>>
>> On Mon, 15 Aug 2011, Jeff Layton wrote:
>>
>>> On Mon, 15 Aug 2011 11:18:38 +0200 (CEST)
>>> Jesper Juhl <jj@chaosbits.net> wrote:
>>>
>>> There was at least one known oops at mount time with 3.0:
>>>
>>>   https://bugzilla.redhat.com/show_bug.cgi?id=727927
>>>
>>> ...but I can't tell whether you hit that w/o seeing the oops messasge.
>>>
>>> It should be fixed in mainline and the patches for that and another
>>> mount time problem will be in the next set of stable kernels. You may
>>> want to pull these two commits into your kernel and try again:
>>>
>>> 80975d21aae2136ccae1ce914a1602dc1d8b0795
>>> f9e8c45002cacad536b338dfa9e910e341a49c31
>>>
>>
>> Thanks,
>>
>> Patches applied to 3.0.1 and will try to mount the CIFS shares later
>> today:
>>
>> # patch -p1 < /home/war/cifs1
>> patching file fs/cifs/cifsfs.c
>> # patch -p1 < /home/war/cifs2
>> patching file fs/cifs/inode.c
>>
>> Justin.
>>
>>
>
> Hello,
>
> It crashed again with the patches, this time I got a picture:
> http://home.comcast.net/~jpiszcz/20110815/26030-kernel-crash-when-cifs-mount.jpg
>
> The machine is up no issues until you try and mount a CIFS share, then
> the problem occurs, every time (and with the patches as well).
>
> 3.0.1+80975d21aae2136ccae1ce914a1602dc1d8b0795
>     +f9e8c45002cacad536b338dfa9e910e341a49c31
>
> Same result.
>
> Justin.
>
>



-- 
Thanks,

Steve
