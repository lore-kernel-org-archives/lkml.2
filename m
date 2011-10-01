Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1JAWMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:12:34 -0400
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53]:40198 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751649Ab1JAWM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:12:27 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 18:12:27 EDT
Message-ID: <4E878F01.7010604@kingswood-consulting.co.uk>
Date: Sat, 01 Oct 2011 23:06:57 +0100
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org>
In-Reply-To: <20111001180641.GD6309@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/11 19:06, Steven Rostedt wrote:
> On Sat, Oct 01, 2011 at 09:35:33AM +0200, Willy Tarreau wrote:
>>
> For my machine that is connected to the outside world, I have a script
> that runs every night that checks for attacks. As bots constantly look
> for port 22 and 80, they find my machine without issue. When my script
> detects a bunch of ssh login attempts that fail, it will add that ip
> address to the iptables DROP chain:
>
> # iptables -L -n | grep DROP | wc -l
> 2656
>
> I've picked up quite a few ;)
>
> This script only runs and scans once at night. Probably better to have
> it run more often.

Limiting SSH accesses to a few a minute (failed or not) is useful to 
block many password guess attacks. I set up mine a long time ago 
following this article using "recent" matches in iptables:

http://www.debian-administration.org/articles/187

You'll want to set the same rules for ipv6.

This won't stop low frequency and distributed attacks, and sometimes but 
extremely rarely I find myself connecting more quickly than the rate limit.

Setting "PasswordAuthentication no" in your sshd_config is good too.

Regards,

Frank

-- 
------------------------------------------------------------------------
Frank A. Kingswood                      frank@kingswood-consulting.co.uk
Cambridge, United Kingdom                               +44-870-095 0000
