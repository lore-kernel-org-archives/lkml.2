Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2EDNAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab2EDNAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:00:32 -0400
Message-ID: <4FA3D2D8.8010906@redhat.com>
Date: Fri, 04 May 2012 09:00:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Don Zickus <dzickus@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, gregkh@linuxfoundation.org
Subject: Re: [RFC PATCH] tty, add kref to sysrq handlers
References: <1335546920-28492-1-git-send-email-prarit@redhat.com> <20120427183922.47436912@pyramind.ukuu.org.uk>
In-Reply-To: <20120427183922.47436912@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/27/2012 01:39 PM, Alan Cox wrote:
>> If the lock were removed, however, there is one _unlikely_ circumstance in
>> which the array would be left unprotected.  That would be the situation in
>> which a module was loaded and the sysrq handler was registered during the
>> execution of the module.  Again, the possibility of the scenario is very
>> small and given the existing usage of unregister_sysrq_key() in the tree
>> it seems like removing the lock is sufficient.
> 
> It's asking for later disasters I think.
> 
> I'm not sure I see we need a kref - that looks like overkill, and its
> probably even more elegantly done with RCU ?

Alan,

Thanks for the suggestions.  As always they are much appreciated.

I looked into this, and unfortunately the RCU implementation in the kernel is
dynamic-list based.  I could do some funky stuff to make it work with an array
or even implement an RCU for arrays but I'm wondering if that is wasted code.

Most arrays in the kernel that require RCU-like locking seem to use seqlocks.
The problem with any lock, unfortunately, is that I would have to still block
irqs, which is exactly what I'm trying to avoid.

I'll submit my patch as a real PATCH and see what everyone thinks of it ...

P.
