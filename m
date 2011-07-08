Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1GHVs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:48:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48599 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1GHVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:48:57 -0400
Date: Fri, 08 Jul 2011 14:48:46 -0700 (PDT)
Message-Id: <20110708.144846.2266757026673899391.davem@davemloft.net>
To: tony.luck@intel.com
Cc: dzickus@redhat.com, mjg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: pstore dump inside an nmi handler
From: David Miller <davem@davemloft.net>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
References: <20110708201731.GA3025@redhat.com>
	<987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 08 Jul 2011 14:48:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Fri, 8 Jul 2011 14:40:13 -0700

>> Inside pstore_dump(), the first thing it tries to grab is a mutex_lock()
>> (inside an nmi hander).  This seems to be the root cause of my problems.
> 
> Someone else pointed out that mutex_lock() is a problem here too. They
> wondered whether spin_lock_irqsave() would work - or whether pstore
> backends were allowed to sleep - to which I said I hoped they didn't,
> but wasn't really sure what the future will hold.
> 
> So ... ideas (and patches) are most welcome.

Probably you'll need to queue things atomically using something
based upon cmpxchg() like the generic ring buffer does.
