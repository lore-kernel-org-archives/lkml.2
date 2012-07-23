Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2GWPEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:04:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55372 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2GWPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
References: <CAP2rAF-ZappKmznEVjd=kQgRx__oVZ3vSE53rWDHVJf6VwMVTA@mail.gmail.com>
	<Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
Date: Mon, 23 Jul 2012 20:34:46 +0530
Message-ID: <CAP2rAF_K8Zg=+ahi23U34nb+Hewh+Xaa64jfQxBxOegN3=AnyA@mail.gmail.com>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
From: Sarbojit Ganguly <unixman.linuxboy@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <zonque@gmail.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2012 20:17, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:
>
>> Hello Daniel,
>>
>> That is why I provided two stacks,
>>
>> 1st one is when I tried to remove the USB hub (which connects a webcam
>> + microphone)
>> 2nd one is when I tried to remove an USB powered external HDD.
>>
>> Just to make sure whether the problem is with USB sound or the USB subsystem.
>
> Do you stop all the programs that are using the USB devices before
> unplugging the hub?  Do you unmount the USB HDD first?

Yes Alan, I did unmount the HDD

>
> The first crash shows a problem in the snd-usb-audio driver.
>
> The second crash shows a problem in the VFS layer or in ext3, not in
> the USB stack.

Yes the issue is in evict() api which gets called when USB disconnect
is triggered.
>
> Alan Stern
>

Even I was confused in the beginning but after thorough check I
confirmed its presence. I reverted back to my distro's stock kernel
(3.2.0-26-generic) where the issue does not recur.

I could not analysed further (due to my limited knowledge of USB).



-- 
Regards,
Sarbojit
