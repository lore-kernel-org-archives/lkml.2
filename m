Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1JRNoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:44:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39329 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab1JRNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D7BD2.8090101@cam.ac.uk>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
 <1318939596-27330-5-git-send-email-ricardo.ribalda@gmail.com> <4E9D7BD2.8090101@cam.ac.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 18 Oct 2011 15:43:28 +0200
Message-ID: <CAPybu_0kxqfo9Lx9V_oOXfBjOG2dnR0NLCV6=PM6cnUYmVb_iQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/7] input/cma3000_d0x: Add CMA3000 spi support
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan

  First of all, thanks for your messages :).

> To make my point about these functions being more complex than needed
> in more detail....
>
> If this were two functions and you drop the zero and 1 mask
> (which I'm not convinced make any sense. I've also killed the message.
> We both agree it is the wrong way to go, so post a patch fixing the i2c
> interface as well.

Of course your functions are much more simpler and beautiful than the
fat one I wrote, no doubt about it :). Just three comments

- Checking the one mask and the zero mask is the only way we have to
know if the chip is still there, The absense of that reply should
trigger an IO error or at least a retry. As you point out, the
zero/one mask is only violated on startup.  I just wanted to make it
more risk free, but if you believe it is more clear that way, lets
remove it

- I am not very fun of kmallocing data per write, specially when it is
part of the irq handler, and you expect this to be low latency. What
about allocating a buffer on init time, and use it with a mutex?

-I dont like the push error message to the bottom, but that will mean
a rewrite of the cma3000 driver, shall I go for it?


Thanks again, and  I will post the new version when you reply this :)


-- 
Ricardo Ribalda
