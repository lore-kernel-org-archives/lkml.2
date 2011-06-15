Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1FOAsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:48:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43514 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1FOAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:48:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Jun 2011 09:41:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: cfowler@opsdc.com
Cc: Chris Fowler <cfowler@outpostsentinel.com>, linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Panic on OOM
Message-Id: <20110615094113.fa89be99.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1308058276.2074.295.camel@compaq-desktop>
References: <1308058276.2074.295.camel@compaq-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 09:31:16 -0400
Chris Fowler <cfowler@outpostsentinel.com> wrote:

> I'm running into a problem in 2.6.38 where the kernel is not doing what
> I'm expecting it to do.  I'm guessing that some things have changed and
> that is what it going on.
> 
> First,  The tune at boot:
> 
>         f.open("/proc/sys/vm/panic_on_oom", std::ios::out);
>         f << "1";
>         f.close();
> 
>         f.open("/proc/sys/kernel/panic", std::ios::out);
>         f << "10";
>         f.close();
> 
> I want the kernel to panic on out of memory.  I then want it to wait 10s
> before doing a reboot.
> 
> This program will consume all memory and make the box unresponsive
> 
> #!/usr/bin/perl
> 
> my @mem = ()
> while(1) {
>   push @mem, "########################";
> }
> 

Hmm, then, OOM-Killer wasn't invoked ?

> It does not take long to fill up 1G of space.  There is NO swap on this
> device and never will be.  I did notice that after a long period of time
> (I've not timed it) I finally do see a panic and I do see "rebooting in
> 10 seconds..." .  It does not reboot.
> 

In these month(after 2.6.38), there has been some discussion
that "oom-killer doesn't work enough or lru scan very slow" problem
in linux-mm list. (and some improvemetns have been done.)

Then, if you can post your 'test case' with precise description of
machine set up, we're glad.

> 
> I'm guessing that there are some tweaks or new behavior I just need to
> be aware of.
> 

What version of kernel did you used in previous setup ?

Thanks,
-Kame



   




