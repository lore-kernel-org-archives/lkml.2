Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649Ab2KBCTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:19:38 -0400
Received: from hibox-130.abo.fi ([130.232.216.130]:57194 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2KBCTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:19:36 -0400
Message-ID: <50932DAC.7040702@hibox.fi>
Date: Fri, 02 Nov 2012 04:19:24 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jack@suse.cz
Subject: Re: Debugging system freezes on filesystem writes
References: <508DB432.2030208@hibox.fi> <20121101190119.GA27294@quack.suse.cz>
In-Reply-To: <20121101190119.GA27294@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.11.2012 21:01, Jan Kara wrote:
> On Mon 29-10-12 00:39:46, Marcus Sundman wrote:
>    Hello,
>
>> I have a big problem with the system freezing and would appreciate
>> any help on debugging this and pinpointing where exactly the problem
>> is, so it could be fixed.
>>
>> So, whenever I write to the disk the system comes to a crawl or
>> freezes altogether. This happens even when the writing processes are
>> running on nice '19' and ionice 'idle'. (E.g. a 10 second compile
>> could freeze the system for several minutes, rendering the computer
>> pretty much unusable for anything interesting.)
>>
>> Here you can see a 20 second gap even in superhigh priority:
>> # nice -n -20 ionice -c1 iostat -t -m -d -x 1 > http://pastebin.com/j5qnh2VV
>>
>> I'm currently running 3.5.0-17-lowlatency on the ZenBook UX31E,
>> using the NOOP I/O scheduler on the SanDisk SSD U100. The chipset
>> seems to be Intel QS67. I've had this same problem on 3.2.0 generic
>> and lowlatency kernels.
>    These are Ubuntu kernels. Any chance to reproduce the issue with vanilla
> kernels - i.e. kernels without any Ubuntu patches?

I'm afraid it's going to take a week to compile a kernel with this 
freezing going on, but I suppose I could get another computer to do the 
compiling. Or should I install some pre-compiled version? If so, which one?

> Also when you speak of
> system freezing - can you e.g. type to terminal while the system is frozen?
> Or is it just that running commands freezes?

Typing usually doesn't work very well. It works for a word or two and 
then stops working for a while and if I continue to type then when it 
resumes only the last few characters appears. Typing in the console is a 
bit better than in a terminal in X (not counting the several minutes it 
can take to switch to the console (Ctrl-Alt-F1)).

> And how much free memory do
> you have while the system is frozen?

It varies. Or it depends on how you look at it, usually my RAM is full, 
but mostly by "buffers" (whatever that is in practice).
My swap is close to zero, because I keep swappiness at 1, or else the 
freezing gets totally out of control.
And I've disabled journaling, because journaling also makes it much, 
much worse. (Using ext4, btw.)

> Finally, can you trigger the freeze by
> something simpler than compilation - e.g. does
>    dd if=/dev/zero of=/tmp bs=1M
> trigger the freeze as well?

Yes, that command sure does trigger the freezes. However, if there's 
nothing else going on then that command doesn't make the system freeze 
totally (at least not immediately), but if I do some other filesystem 
activity (e.g., ls) at the same time then the freezing starts.

Also, and this might be important, according to iotop there is almost no 
disk writing going on during the freeze. (Occasionally there are a few 
MB/s, but mostly it's 0-200 kB/s.) Well, at least when an iotop running 
on nice -20 hasn't frozen completely, which it does during the more 
severe freezes.


Regards,
Marcus

