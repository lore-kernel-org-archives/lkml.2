Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1FOCES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:04:18 -0400
Received: from support.opsdc.com ([65.254.219.9]:37107 "EHLO support.opsdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab1FOCEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:04:16 -0400
Subject: Re: Panic on OOM
From: Chris Fowler <cfowler@outpostsentinel.com>
Reply-To: cfowler@opsdc.com
To: David Rientjes <rientjes@google.com>
Cc: Chris Fowler <cfowler@opsdc.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 22:04:03 -0400
Message-ID: <1308103443.2074.357.camel@compaq-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 17:13 -0700, David Rientjes wrote:
> Using /proc/sys/vm/panic_on_oom also won't panic the machine if you
> happen to use a cpuset or mempolicy.  You'll want to write '2' instead
> if you want to panic in all possible oom conditions.
> 
> 

2 did it.  Thank you.

perl -e 'my @mem = (); while(1) { push @mem, "XXXXXXXXXXXXXXXX"; }'

I lost connection and it came back after about 30s.  Reboot worked.

In the past I've had OOM conditions "lock" a device so to keep from
having to call someone to reboot it I started using this method instead.
Out of memory conditions are rare and would only be caused by memory
leaks.  I've found all memory leaks that I could fine and the first OOM
condition was caused by the program doing exactly what I told it to
do. :)

On the device that is running 2.6.38 this is the first time I'm planning
on using some PERL code on the device.  I am a bit concerned about
possibly memory leaks taking down the device so I wanted to be sure this
works.  This box does not have any swap space and never real.  The 1G of
memory will be all that is available.

Thanks,
Chris

