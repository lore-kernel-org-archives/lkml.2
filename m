Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2EARB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:01:58 -0400
Received: from tex.lwn.net ([70.33.254.29]:34253 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab2EARB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:01:57 -0400
Date: Tue, 1 May 2012 11:01:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-bluetooth@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120501110156.2b6e0561@lwn.net>
In-Reply-To: <20120501073711.028d31d6@lwn.net>
References: <20120501073711.028d31d6@lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012 07:37:11 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> I have a logitech Dinovo Edge bluetooth keyboard that I've used for
> years.  With 3.4 kernels, the keyboard generates no input until I've
> banged on it for a couple of seconds.  If I continually hit characters,
> they make it through; as soon as I stop for even a brief period (even
> somebody as verbose as me has to come up for air occasionally), it goes
> back to sleep.

OK, git bisect has rendered its verdict:

d35e70d50a0641ebc1502fd343bef9b4011ada27 is the first bad commit
commit d35e70d50a0641ebc1502fd343bef9b4011ada27
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Feb 3 17:11:55 2012 -0500

    usb: Use hub port data to determine whether a port is removable
    
    Hubs have a flag to indicate whether a given port carries removable devices
    or not. This is not strictly accurate in that some built-in devices
    will be flagged as removable, but followup patches will make use of platform
    data to make this more reliable.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

...and, indeed, things do seem to break right there.

I assume there's something funky about the (oldish) USB bluetooth dongle
that came with my keyboard that interacts badly with this patch.  Matthew,
is there anything I can do or tell you to help figure this one out?

Thanks,

jon
