Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0GNPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:21:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:43520 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0GNPVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:21:17 -0400
Message-ID: <4C3DD5EB.9070908@tmr.com>
Date: Wed, 14 Jul 2010 11:21:15 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Ed W <lists@wildgooses.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
References: <4C3D94E3.9080103@wildgooses.com>
In-Reply-To: <4C3D94E3.9080103@wildgooses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed W wrote:
> Hi, my network connection looks like 500Kbits with a round trip latency 
> of perhaps 1s+ (it's a satellite link).
> 
>  From what I can see the linux initial congestion window is signficantly 
> limiting me here, with slow start taking many many seconds to open up 
> the window wide enough to get the data flowing?  For protocols like http 
> this is really hurting with all the short lived connections never really 
> getting up to speed.  (throw in some random packet loss and things 
> really screech to a halt)
> 
> Reading around there appear to be several previous attempts to modify 
> the kernel to start with a slightly wider initial congestion window, say 
> 10 packets.  (Seems even google did some work on this and agreed that a 
> small of initial cwd to 10 ish, would help even many non satellite 
> users?) However, all the work I can find is quite old and doesn't seem 
> to give me much of a leg up in terms of experimenting with such changes 
> on a modern kernel?
> 
> Does someone have some pointers on where to look to modify initial 
> congestion window please?
> 
Are you sure that's the issue? The backlog is in incoming, is it not?

Having dealt with moderately long delays push TB between timezones, have you set 
your window size up? Set /proc/sys/net/ipv4/tcp_adv_win_scale to 5 or 6 and see 
if that helps. You may have to go into /proc/sys/net/core and crank up the 
rmem_* settings, depending on your distribution.

This allows the server to push a lot of data without an ack, which is what you 
want, the ack will be delayed by the long latency, so this helps. You can 
calculate how large to make the setting, but "make it bigger until tcpdump never 
shows the window size < 2k" is the best way, even a bit larger than that wont 
hurt, although it will take a bit of memory.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
