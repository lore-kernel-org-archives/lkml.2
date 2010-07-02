Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab0GBJI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:08:28 -0400
Received: from lo.gmane.org ([80.91.229.12]:41109 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab0GBJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:08:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Date: Fri, 2 Jul 2010 09:09:37 +0100
Message-ID: <1fj0g7-ljk.ln1@chipmunk.wormnet.eu>
References: <20100628230035.GA18971@dtor-ws.eng.vmware.com> <201007011531.52291.dtor@vmware.com> <20100701154347.e3c1094b.akpm@linux-foundation.org> <201007011600.00462.dtor@vmware.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dtor@vmware.com> wrote:
>
>> > Now we have 2 drivers fighting. There is no backing device and so driver
>> > core will not save us by refusing to bind to already claimed device.
>> 
>> If vmware_balloon is present in /sys/modules or is loaded, don't load
>> vmmemctl.  And vice versa.
>> 
>> I dunno - it's silly for me to sit here proposing solutions.  it's
>> better that you do it!
> 
> Unfortunately I do not have a good solution at the moment. I guess we'll
> have to work with distributions to make sure they keep it as a module
> (it also makes most sense for them since not everyone runs on our
> platform).
> 
I cannot seriously believe you are considering a viable solution is 
"everyone[1] must abide by these rules otherwise our installer might 
barf".  The only benefactor of this patch is your installer and the 
effect is an undocumented and peculiar constraint on a kernel module.

Seriously, add sometime so that you get something in /sys/modules (maybe 
it's time for something in /sys/class?) or maybe do something so that 
you have: VMWARE_BALLOON_CMD(STATUS, ...) where the guest can say if 
there is already something ballooning for it.  Surely the guest should 
be aware if there is more than one balloon driver at play?

I think a friend of mine summed it up rather well: "Fixing the kernel 
instead of fixing the VMWare installer is an inspired move".

Cheers

[1] the dropdown menu on distrowatch lists 319 distrubutions

-- 
Alexander Clouter
.sigmonster says: May the bluebird of happiness twiddle your bits.

