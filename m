Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2G1LNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:13:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53687 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2G1LNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:13:17 -0400
Message-ID: <5013C948.3000802@gmail.com>
Date: Sat, 28 Jul 2012 13:13:12 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sarbojit Ganguly <unixman.linuxboy@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
References: <CAP2rAF-ZappKmznEVjd=kQgRx__oVZ3vSE53rWDHVJf6VwMVTA@mail.gmail.com> <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org> <CAP2rAF_K8Zg=+ahi23U34nb+Hewh+Xaa64jfQxBxOegN3=AnyA@mail.gmail.com>
In-Reply-To: <CAP2rAF_K8Zg=+ahi23U34nb+Hewh+Xaa64jfQxBxOegN3=AnyA@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2012 17:04, Sarbojit Ganguly wrote:
> On 23 July 2012 20:17, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:
>>
>>> Hello Daniel,
>>>
>>> That is why I provided two stacks,
>>>
>>> 1st one is when I tried to remove the USB hub (which connects a webcam
>>> + microphone)
>>> 2nd one is when I tried to remove an USB powered external HDD.
>>>
>>> Just to make sure whether the problem is with USB sound or the USB subsystem.
>>
>> Do you stop all the programs that are using the USB devices before
>> unplugging the hub?  Do you unmount the USB HDD first?
> 
> Yes Alan, I did unmount the HDD
> 
>>
>> The first crash shows a problem in the snd-usb-audio driver.
>>
>> The second crash shows a problem in the VFS layer or in ext3, not in
>> the USB stack.
> 
> Yes the issue is in evict() api which gets called when USB disconnect
> is triggered.
>>
>> Alan Stern
>>
> 
> Even I was confused in the beginning but after thorough check I
> confirmed its presence. I reverted back to my distro's stock kernel
> (3.2.0-26-generic) where the issue does not recur.
> 
> I could not analysed further (due to my limited knowledge of USB).
> 

Did you succeed in bisecting this problem down? From what I can tell,
there hasn't been any similar report on LKML yet. That makes traking the
problem on your machine even more important as you can reproduce it
reliably.


Thanks,
Daniel

