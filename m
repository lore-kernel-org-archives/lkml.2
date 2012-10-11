Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2JKIU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab2JKIUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:20:23 -0400
Message-ID: <5076819C.9010504@redhat.com>
Date: Thu, 11 Oct 2012 10:21:48 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs: Use-scatter-gather-lists-for-large-bulk-transfers
References: <20121010203118.GA792@polaris.bitmath.org>
In-Reply-To: <20121010203118.GA792@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/10/2012 10:31 PM, Henrik Rydberg wrote:
> Hi Hans, Alan, Greg,
>
> commit 3d97ff63f8997761f12c8fbe8082996c6eeaba1a
> Author: Hans de Goede <hdegoede@redhat.com>
> Date:   Wed Jul 4 09:18:03 2012 +0200
>
>      usbdevfs: Use scatter-gather lists for large bulk transfers
>
> breaks an usb programming cable over here. The problem is reported as
> "bulk tranfer failed" [sic] by the tool, and bisection leads to this
> commit. Reverting on top of 3.6 solves it for me.

Oh what fun (not). The best way to figure out what really is going
on is to get some usb level traces. Note my first hunch is that what
you're seeing is a device firmware bug, as this patch together with
a new libusb (which you seem to also have) will make bulk transfers
run slightly faster, which might be just enough to overwhelm your
device ...

Can you please do the following:
1) unplug as many usb devices as possible
2) plug in the programmer
3) run lsusb, note the programmer bus number
4) if the programmer is one the same bus as another device (other then
    a hub), try a different port
5) ideally rinse repeat until it is on a bus of its own, or atleast
    a bus with a device which generate little trafic
6) Writedown the bus number, and keep using the same port for
    all further tests

Then:
1) start wireshark as root, tell it to start capturing on the USB bus
you've ended up using
2) Do what you always do with the programmer
3) When finished, or when things have failed stop wireshark capture and
save the capture to a file

Repeat 2 times once with a kernel with the problematic commit, once without.

Then send me the 2 wireshark captures. Note:

1) Privacy warning: In theory I might be able to reconstruct what you're sending
over the captured USB bus when you send me these captures
2) Less is more, so if you can find some mini mini program to send to the
device you're programming that makes live easier (and should make 1 less of
an issue too).

Regards,

Hans
