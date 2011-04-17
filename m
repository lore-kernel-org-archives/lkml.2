Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1DQTgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 15:36:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1DQTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 15:35:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Thilo-Alexander Ginkel" <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Sun, 17 Apr 2011 21:35:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com> <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
In-Reply-To: <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172135.40189.arnd@arndb.de>
X-Provags-ID: V02:K0:GwBDmdeQVda4LCb6nIg7N/ENVjEWXqyIB12r65S9yum
 R6FbvXTX2zeeYPWXknvL0Zult23NT0w9JNjzwv8MsX+rmI1xXV
 hWiadGBlWT/N8ghvtzW9S2fCHuRWDa9ybn7p1utOj8ggA6fXLW
 8x40gvP5n1G7WeNDXonIFvLc6lJWZdJa7ktyDQ2Fqy/eMfbekc
 7tOsnxsp9T+VO6obCj/fg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 April 2011, Thilo-Alexander Ginkel wrote:
> All right... I verified all my bisect tests and actually found yet
> another bug. After correcting that one (and verifying the correctness
> of the other tests), git bisect actually came up with a commit, which
> makes some more sense:
> 
> | e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
> | commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
> | Author: Tejun Heo <tj@kernel.org>
> | Date:   Tue Jun 29 10:07:14 2010 +0200
> |
> |     workqueue: implement concurrency managed dynamic worker pool

Is it possible to make it work by reverting this patch in 2.6.38?

> The good news is that I am able to reproduce the issue within a KVM
> virtual machine, so I am able to test for the soft lockup (which
> somewhat looks like a race condition during worker / CPU shutdown) in
> a mostly automated fashion. Unfortunately, that also means that this
> issue is all but hardware specific, i.e., it most probably affects all
> SMP systems (with a varying probability depending on the number of
> CPUs).
> 
> Adding some further details about my configuration (which I replicated
> in the VM):
> - lvm running on top of
> - dmcrypt (luks) running on top of
> - md raid1
> 
> If anyone is interested in getting hold of this VM for further tests,
> let me know and I'll try to figure out how to get it (2*8 GB, barely
> compressible due to dmcrypt) to its recipient.

Adding dm-devel to Cc, in case the problem is somewhere in there.

	Arnd
