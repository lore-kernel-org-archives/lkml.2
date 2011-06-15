Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1FOCcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:32:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24628 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1FOCcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CE/ED9+eyM89SZpWdBuHJb5iJCEAxAoZNtRP3MNSQVhGHQ8o4h93WEwjmPqOz1JyHV
         dwvrLZg3+38Bhb2f/R5w==
Date: Tue, 14 Jun 2011 19:32:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Chris Fowler <cfowler@opsdc.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic on OOM
In-Reply-To: <1308103443.2074.357.camel@compaq-desktop>
Message-ID: <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop> <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com> <1308103443.2074.357.camel@compaq-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Chris Fowler wrote:

> > Using /proc/sys/vm/panic_on_oom also won't panic the machine if you
> > happen to use a cpuset or mempolicy.  You'll want to write '2' instead
> > if you want to panic in all possible oom conditions.
> > 
> > 
> 
> 2 did it.  Thank you.
> 
> perl -e 'my @mem = (); while(1) { push @mem, "XXXXXXXXXXXXXXXX"; }'
> 
> I lost connection and it came back after about 30s.  Reboot worked.
> 

That wasn't meant as a fix for the problem but rather just a suggestion 
based on how you're using the device.

It's just a coincidence that it worked that time, because 
/proc/sys/vm/panic_on_oom == 2 is the exact same as 
/proc/sys/vm/panic_on_oom == 1 with the .config you posted (since you 
don't have CONFIG_NUMA, constrained_alloc() always returns CONSTRAINT_NONE 
in the oom killer).

More supporting evidence is that in the initial report that you said you 
had seen the panic and "Rebooting in 10 seconds..." message, yet no 
reboot.  That indicates the oom killer is working fine in both conditions.

So it's definitely the reboot code that is causing an issue that either 
hangs or takes excessively long, and that only happens sporadically for 
your machine.  The only differences between this code between v2.6.33 and 
v2.6.38 is how reboots are handled for Dell Precision T7400, VersaLogic 
Menlow based, and Apple iMac9,1.
