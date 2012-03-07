Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab2CGTO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:14:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759718Ab2CGTO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:14:26 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
	<CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com>
	<20120306164835.GA26094@elliptictech.com>
	<CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com>
	<x49mx7thabf.fsf@segfault.boston.devel.redhat.com>
	<4F578198.8060708@linux.vnet.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 07 Mar 2012 14:14:21 -0500
In-Reply-To: <4F578198.8060708@linux.vnet.ibm.com> (Srivatsa S. Bhat's message
	of "Wed, 07 Mar 2012 21:11:12 +0530")
Message-ID: <x49ipigustu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:

> On 03/06/2012 11:38 PM, Jeff Moyer wrote:
>
>> Sasha Levin <levinsasha928@gmail.com> writes:
>> 
>>> I can't reproduce it locally with a 3.3-rc5 kernel.
>> 
>> First, thanks for looking into it.  I just did a git pull, up to -rc6,
>> and the problem still persists on my machine.
>>
>
>
> I tried 3.3-rc4 as well as 3.3-rc6+ (last commit dac12d1). I did not
> see the problem in either case.

I bisected the issue, and it landed here:

8a25a2fd126c621f44f3aeaef80d51f00fc11639 is the first bad commit
commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Wed Dec 21 14:29:42 2011 -0800

    cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular
    subsystem

Unfortunately, that's a HUGE commit.

-Jeff
