Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2D3WwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:52:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32905 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673Ab2D3WwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:52:19 -0400
Message-ID: <4F9F178F.3030408@zytor.com>
Date: Mon, 30 Apr 2012 15:51:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, linux-pm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
References: <20120501082209.0b560708@notabene.brown>
In-Reply-To: <20120501082209.0b560708@notabene.brown>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 03:22 PM, NeilBrown wrote:
> 
> What I would really like is to integrate it closely with the state
> of the UART.  i.e. if the /dev/ttyO1 device is open, then the GPS
> is "on".  If not then it is "off".  Similarly if /dev/tty/O0 is
> open, bluetooth is "on", else "off". However I cannot find any way
> to "plug in" to the tty or serial drivers to perform an arbitrary
> action on first-open or last-close.  Is something like that
> possible? If not, is it a reasonable thing to ask? Any suggests
> about where to put such a hook?
> 

I don't think that's the right interface.  Just because the port is
currently open doesn't mean the device is active, nor vice versa.  ALL
it means is that someone currently has an access handle to it.

Since a serial port models, well, a *port*, it is logical to think of
a (hypothetical) socket containing an RS-232 connector as well as a
power outlet.  Given that, it would be logical to drive the "power
connector" using the same type of interface used for the other parts
of an RS-232 control, meaning either with termios flags or via a
dedicated control ioctl (TIOCPOWER?).

	-hpa

