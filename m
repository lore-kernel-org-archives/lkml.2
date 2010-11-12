Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0KLSun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:50:43 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:49680 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0KLSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:50:41 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 13:50:40 EST
Message-ID: <4CDD8B51.6080004@telenet.be>
Date: Fri, 12 Nov 2010 19:45:37 +0100
From: Jef Driesen <jefdriesen@telenet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
In-Reply-To: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/10 19:25, Linus Torvalds wrote:
> Greg, Alan, Hirofumi-san,
>
>   I thought we long since (ie back last fall) fixed the latency
> problems with pty's, but there does seem to be something very fishy
> going on there still.
>
> On Thu, Jun 10, 2010 at 8:01 AM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> On Sat, May 29, 2010 at 12:53 PM, Jef Driesen<jefdriesen@telenet.be>  wrote
>>> BTW, now that I have your attention, could you maybe help me with a linux
>>> kernel problem I'm experiencing in this area? I reported the problem on LKML
>>> but got no response:
>>>
>>> http://www.divesoftware.org/libdc/simulator.html
>>> http://groups.google.com/group/linux.kernel/browse_thread/thread/5a2b00e35b0864a7
>>
>> [ Hmm.. Testing.. ]
>>
>> Yeah, it's slow. Your test thing takes one and a quarter minutes for
>> me. That's ridiculous.
>>
>> And no, we shouldn't need the low-latency flag, we're supposed to do
>> this all automatically correctly. I'll talk to the tty people.
>
> This is clearly not a regression (it's been going on forever, I
> suspect), but taking over a minute to transfer just over half a MB of
> data over a pty seems crazy.
>
> Maybe it's not a kernel problem, and it's something done wrong by
> rx/sx/socat, I haven't looked at what they do. But since setting
> low_latency apparently helps (I didn't test that part, but I did test
> "ridiculously slow"), it sounds very much like something is still
> wrong in the kernel unless there is some really subtle timing issue in
> user space.
>
>> From Jef's original lkml report linked to above:
>
>> You can reproduce the problem by running these commands in three
>> different terminals:
>>
>> # Terminal 1: Setup the pty's.
>> socat PTY,link=/tmp/ttyS0 PTY,link=/tmp/ttyS1
>> # Terminal 2: Send some data.
>> dd if=/dev/urandom of=input.bin bs=538368 count=1
>> sx input.bin>>/tmp/ttyS0</tmp/ttyS0
>> # Terminal 2: Receive the data data.
>> time rx output.bin>/tmp/ttyS1</tmp/ttyS1
>
> and yeah, it's pretty clear to see. A "perf report" on that receiving
> side just shows queue_delayed_work_on(), but that doesn't mean much.
> It's clearly just sleeping all the time...
>
> Any ideas?
>
>                       Linus

Just out of curiosity, is there any progress on this issue? There was 
some discussion on NOHZ related changes in the remainder of this thread, 
but they don't appear to have fixed the problem I reported above. I 
still need to patch my kernel to set the low-latency flag to get decent 
performance.

I wish I could look into this myself, but unfortunately my kernel 
experience is still too limited. But if there is anything that I could 
do to help, just let me know.

Thanks for your time.

Jef
