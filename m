Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab0JVTtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:49:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39315 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab0JVTtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:49:41 -0400
Message-ID: <4CC1EACC.9040500@kernel.dk>
Date: Fri, 22 Oct 2010 21:49:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Cameron <smcameron@yahoo.com>
CC: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mike.miller@hp.com, thenzl@redhat.com
Subject: Re: [PATCH 3/5] cciss: Use kernel provided PCI state save and restore
 functions
References: <402956.74986.qm@web33003.mail.mud.yahoo.com>
In-Reply-To: <402956.74986.qm@web33003.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-22 21:36, Stephen Cameron wrote:
> --- On Fri, 10/22/10, Stephen M. Cameron <scameron@beardog.cce.hp.com> wrote:
> 
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>> Subject: [PATCH 3/5] cciss: Use kernel provided PCI state save and restore functions
>> To: axboe@kernel.dk
>> Cc: akpm@linux-foundation.org, smcameron@yahoo.com, linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
>> Date: Friday, October 22, 2010, 2:21 PM
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>
>> and use the doorbell reset method if available (which doesn't
>> lock up the controller if you properly save and restore
>> all the PCI registers that you're supposed to.)
> 
> 
> This patch, and all these cciss patches in this series, are vs. the jens/for-2.6.37/drivers branch.
> 
> One difference I noticed between linux-2.6.36 and jens/for-2.6.37/drivers is that linux-2.6.36 contains this in drivers/block/cciss.c
> in the function cciss_kdump_hard_reset_controller:
> 
>         /* The doorbell reset seems to cause lockups on some Smart
>          * Arrays (e.g. P410, P410i, maybe others).  Until this is
>          * fixed or at least isolated, avoid the doorbell reset.
>          */
>         use_doorbell = 0;
> 
> This is not present in jens/for-2.6.37/drivers.
> 
> That was added to linus tree by me, because I'd noticed we were
> getting controller lockups and subsequent data corruption when
> attempting kdumps using the doorbell reset when (unbeknownst to me at
> the time) the pci state saving and restoring code wasn't quite right.
> So these patches fix the pci state saving and restoring code, so the
> above "use_doorbell = 0" needs to come out when these patches go into
> Linus's tree.  But such a patch cannot be made vs. Jens's tree,
> because that code isn't in Jens's tree.

I sent a pull request to Linus earlier today and I know the drivers
branch merges cleanly into -git, so we should be fine.

I'll get this series queued up as well, but it'll be for a later round
early next week. JFYI.

-- 
Jens Axboe

