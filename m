Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1C1WrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:47:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55835 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1C1WrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:47:06 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snizer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] Please revert a91a2785b20
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
Date: Mon, 28 Mar 2011 18:45:37 -0400
In-Reply-To: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
	(Thomas Gleixner's message of "Tue, 29 Mar 2011 00:35:20 +0200
	(CEST)")
Message-ID: <yq1hbamkgoe.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D910F95.00BA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Thomas" == Thomas Gleixner <tglx@linutronix.de> writes:

Thomas,

Thomas> But the changelog does not give the courtesy of explaining these
Thomas> changes. Also there is no fcking reason why the kernel cannot
Thomas> deal with the missing integrity capabilities of a drive just by
Thomas> emitting a warning msg and dealing gracefully with the outcome.

My mistake. I was made aware of it earlier today and I'm working on a
patch. Surprised we didn't see any reports of this in -next. It's been
in there for a while.


Thomas> All my RAID setups have been working perfectly fine until now,
Thomas> so what's the rationale to break this?

People were complaining about excessive mempool usage with the block
integrity bits enabled (thanks to MD and DM allocating a bioset per
device to prevent deadlocks).

Making allocation conditional meant we had to deal with memory
allocation errors in the setup path. I tested various combinations of on
and off but apparently not all off. Sorry about that.

-- 
Martin K. Petersen	Oracle Linux Engineering
