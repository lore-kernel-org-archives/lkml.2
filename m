Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab2CMHWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:22:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56656 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab2CMHWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:22:21 -0400
Date: Tue, 13 Mar 2012 00:18:42 -0700 (PDT)
Message-Id: <20120313.001842.1454669292182923878.davem@davemloft.net>
To: apenwarr@gmail.com
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fdinitto@redhat.com, hannes@cmpxchg.org, olaf@aepfle.de,
        paul.gortmaker@windriver.com, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHqTa-3sMRJ0p7driNF+d=f_NZNCF-+TWnCSNO2efEdfv0ayVQ@mail.gmail.com>
References: <CAHqTa-3DiZhd_yoRTzp2Np0Rp=_zrfL7CbN_twu+ZZeu7f4ENg@mail.gmail.com>
	<20120312.235002.344576347742686103.davem@davemloft.net>
	<CAHqTa-3sMRJ0p7driNF+d=f_NZNCF-+TWnCSNO2efEdfv0ayVQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 13 Mar 2012 00:18:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 03:14:21 -0400

> On Tue, Mar 13, 2012 at 2:50 AM, David Miller <davem@davemloft.net> wrote:
>> The idea is that you call prom_retain() before you take a look at what
>> physical memory is available in the kernel, and the firmware takes
>> this physical chunk out of those available memory lists upon
>> prom_retain() success.
> 
> This sounds like exactly the API I would have wanted, however:
> 
> 1) It's only available in arch/sparc so I can't test my patch if I try
> to use it;
> 2) There's nobody that calls it so it might not work;
> 3) I don't understand the API so I'm not really confident that
> reserving memory this way will actually prevent it from being seen by
> the kernel.
> 
> In short, I think I would screw it up.

I'm only saying that you should design your stuff such that an
architecture with such features could easily hook into it using this
kind facility.
