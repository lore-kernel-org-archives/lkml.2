Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1JASGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:06:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1JASGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:06:43 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=wom5GMh1gUkA:10 a=eaZrqAE3U5cA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=x6bNOJp5RZ1wrqbAFGUA:9 a=6K_oOFYPMrdneevBWZsA:7 a=CjuIK1q_8ugA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Date: Sat, 1 Oct 2011 14:06:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001180641.GD6309@home.goodmis.org>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001073533.GA18690@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001073533.GA18690@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:35:33AM +0200, Willy Tarreau wrote:
> 
>   - last considerations to keep in mind is that machines which receive
>     incoming connections from outside should never be able to go out, and
>     should be isolated in their own LAN. It's not hard to do at all, and
>     it massively limits the ability to bounce between systems and to steal
>     information. It also makes firewall logs much more meaningful, provided
>     they are stored on a support with limited access, of course :-)

For my machine that is connected to the outside world, I have a script
that runs every night that checks for attacks. As bots constantly look
for port 22 and 80, they find my machine without issue. When my script
detects a bunch of ssh login attempts that fail, it will add that ip
address to the iptables DROP chain:

# iptables -L -n | grep DROP | wc -l
2656

I've picked up quite a few ;)

This script only runs and scans once at night. Probably better to have
it run more often.

If any one is interested in this simple script, I can send it to them.
I'd have to audit it to make sure that it doesn't expose anything else
that may be of security to me (other machine IPs that I don't want
public, etc).

-- Steve

