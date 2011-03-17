Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1CQAP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:15:27 -0400
Received: from kroah.org ([198.145.64.141]:38575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1CQAPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:15:24 -0400
Date: Wed, 16 Mar 2011 17:15:19 -0700
From: Greg KH <greg@kroah.com>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression from 2.6.36
Message-ID: <20110317001519.GB18911@kroah.com>
References: <20110315132527.130FB80018F1@mail1005.cent>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315132527.130FB80018F1@mail1005.cent>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 02:25:27PM +0100, azurIt wrote:
> 
> Hi,
> 
> we are successfully running several very busy web servers on 2.6.32.* and
> few days ago I decided to upgrade to 2.6.37 (mainly because of blkio cgroup).
> I installed 2.6.37.2 on one of the servers and very strange things started to
> happen with Apache web server.
> 
> We are using Apache with MPM-ITK ( http://mpm-itk.sesse.net/ ) so it is doing
> lots of 'fork' and lots of 'setuid'. I have also noticed that problem is
> happening only on very busy servers.
> 
> Everything is ok when Apache is started but as time is passing by, its 'root'
> processes (Apache processes running under root) are consuming more and more CPU.
> Finally, the whole server becames very unstable and Apache must be restarted.
> This is repeating until the load on web sites is much lower (usually on 22:00).
> Sometimes it takes 3 hours when restart is needed, sometimes only 1 hour (again,
> depends on load on web sites). Here is the graph of CPU utilization showing the
> problem (red color), Apache was REstarted at 8:11 and 9:35:
> http://watchdog.sk/lkml/cpu-problem.png
> 
> Here is how it looks on htop:
> http://watchdog.sk/lkml/htop.jpg
> 
> And finally here is how it looks with older kernels (yes, when i install older
> kernel, problem is gone), notice also that I/O wait is much lower and nicer
> (blue color):
> http://watchdog.sk/lkml/cpu-ok.png
> 
> I was also strace-ing Apache processes which were doing problems, here it is:
> http://watchdog.sk/lkml/strace.txt
> 
> I'm not 100% sure but I think that CPU was consumed on 'futex' lines.
> 
> I tried several kernel versions and find out that everything BEFORE 2.6.36 is
> NOT affected and everything AFTER 2.6.36 (included) is affected.
> 
> Versions which I tried and were NOT affected by this problem:
> 2.6.32.*
> 2.6.35.11
> 
> Versions which I tried and were affected by this problem:
> 2.6.36
> 2.6.36.4
> 2.6.37.2
> 2.6.37.3
> 2.6.38-rc8 (final version was not released yet)
> 
> All tests were made on vanilla kernels on Debian Lenny with this config:
> http://watchdog.sk/lkml/config
> 
> Do you need any other information from me ? I'm able to try other versions or
> patches but, please, take into account that I have to do this on _production_
> server (I failed to reproduce it in testing environment). Also, I'm able to try
> only one kernel per day.

Ick, one kernel per day might make this a bit difficult, but if there
was any way you could use 'git bisect' to try to narrow this down to the
patch that caused this problem, it would be great.

You can mark 2.6.35 as working and 2.6.36 as bad and git will go from
there and try to offer you different chances to find the problem.

thanks,

greg k-h
