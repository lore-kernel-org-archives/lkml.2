Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2JJTw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:52:27 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61333 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2JJTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:52:23 -0400
Date: Thu, 11 Oct 2012 04:52:16 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Mike Galbraith <mgalbraith@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: stable backport: sched: Fix migration thread runtime bogosity
Message-ID: <20121010195216.GA3928@kroah.com>
References: <1349897043.24256.63.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349897043.24256.63.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 03:24:03PM -0400, Steven Rostedt wrote:
> Greg, Ben,
> 
> Can you add this commit to the stable branches. Without it, the
> migration thread's accounting is just totally screwed up:
> 
> By running a simple shell while loop along with a ps loop, top shows:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
>    17 root      RT   0     0    0    0 S 9999.0  0.0   9:27.50 migration/3    
>    13 root      RT   0     0    0    0 S 128.2  0.0   9:50.23 migration/2       
>  2805 root      20   0  105m 1904 1416 S 13.9  0.1   0:06.69 bash               
>  4090 root      20   0  105m 1904 1416 S  2.0  0.1   0:00.90 bash               
>  2773 root      20   0 85484 3372 2620 S  0.3  0.2   0:00.03 sshd               
> 
> 
> For 3.4, the commit can be directly cherry picked:
> 
> commit 8f6189684eb4e85e6c593cd710693f09c944450a
> Author: Mike Galbraith <mgalbraith@suse.de>
> Date:   Sat Aug 4 05:44:14 2012 +0200
> 
>     sched: Fix migration thread runtime bogosity

Now applied to 3.4-stable queue.

greg k-h
