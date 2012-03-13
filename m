Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2CMIUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:20:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57225 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2CMIUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:20:03 -0400
Date: Tue, 13 Mar 2012 01:16:33 -0700 (PDT)
Message-Id: <20120313.011633.151968036751263435.davem@davemloft.net>
To: apenwarr@gmail.com
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fdinitto@redhat.com, hannes@cmpxchg.org, olaf@aepfle.de,
        paul.gortmaker@windriver.com, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHqTa-2c7pOTicWO8stNJfVfep4gSPHwKdr3kv_Jk-oi=dU5bw@mail.gmail.com>
References: <CAHqTa-3sMRJ0p7driNF+d=f_NZNCF-+TWnCSNO2efEdfv0ayVQ@mail.gmail.com>
	<20120313.001842.1454669292182923878.davem@davemloft.net>
	<CAHqTa-2c7pOTicWO8stNJfVfep4gSPHwKdr3kv_Jk-oi=dU5bw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 13 Mar 2012 01:16:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 04:10:42 -0400

> On Tue, Mar 13, 2012 at 3:18 AM, David Miller <davem@davemloft.net> wrote:
>> I'm only saying that you should design your stuff such that an
>> architecture with such features could easily hook into it using this
>> kind facility.
> 
> How about this?

Function signature looks good.

But on a platform with firmware based memory retaining facilitites
we're going to need to invoke this way before bootmem or memblocks are
even setup, because the retain call influences the free memory lists
that the firmware gives to us and those free memory lists are what we
use to populate the memblock tables.
