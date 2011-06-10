Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab1FJWar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:30:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11961 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VQzDuH9clBeN55HW+H1FiMOUH9Xv3SlyU/9NY+HqBxERrHhYncL72vnlXF9qYGPaZt
         0HIuK30jJ/LOx5vLV9JQ==
Date: Fri, 10 Jun 2011 15:30:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <20110610222020.GP24424@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1106101526390.24646@chino.kir.corp.google.com>
References: <alpine.LFD.2.02.1106012134120.3078@ionos> <4DF1C9DE.4070605@jp.fujitsu.com> <20110610004331.13672278.akpm@linux-foundation.org> <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com> <20110610091233.GJ24424@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106101150280.17197@chino.kir.corp.google.com> <20110610185858.GN24424@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1106101456080.23076@chino.kir.corp.google.com> <20110610220748.GO24424@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106101510000.23076@chino.kir.corp.google.com> <20110610222020.GP24424@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Russell King - ARM Linux wrote:

> So those platforms which don't have a DMA zone, don't have any problems
> with DMA, yet want to use the very same driver which does have a problem
> on ISA hardware have to also put up with a useless notification that
> their kernel might be broken?
> 
> Are you offering to participate on other architectures mailing lists to
> answer all the resulting queries?
> 

It all depends on the wording of the "warning", it should make it clear 
that this is not always an error condition and only affects certain types 
of hardware which the user may or may not have.  If you have any 
suggestions on how to alter "task (pid): attempted to allocate DMA memory 
without DMA support -- enable CONFIG_ZONE_DMA if needed" to make that more 
clear, be my guest.  The alternative is that the ISA hardware cannot 
handle the memory returned fails unexpectedly and randomly without any 
clear indication of what the issue is.  I think what would be worse is 
time lost for someone to realize CONFIG_ZONE_DMA isn't enabled, and that 
could be significant (and probably generate many bug reports on its own) 
since it isn't immediately obvious without doing some debugging.
