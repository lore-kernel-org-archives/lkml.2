Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0DGHSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:18:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33439
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932452Ab0DGHSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:18:46 -0400
Date: Wed, 07 Apr 2010 00:18:48 -0700 (PDT)
Message-Id: <20100407.001848.257489037.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: benh@kernel.crashing.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Arch specific mmap attributes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100407161203.FB81.A69D9226@jp.fujitsu.com>
References: <20100407095145.FB70.A69D9226@jp.fujitsu.com>
	<20100407.000343.181989028.davem@davemloft.net>
	<20100407161203.FB81.A69D9226@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed,  7 Apr 2010 16:14:29 +0900 (JST)

>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Date: Wed,  7 Apr 2010 15:03:45 +0900 (JST)
>> 
>> > I'm not against changing kernel internal. I only disagree mmu
>> > attribute fashion will be become used widely.
>> 
>> Desktop already uses similar features via PCI mmap
>> attributes and such, not to mention MSR settings on
>> x86.
> 
> Probably I haven't catch your mention. Why userland process
> need to change PCI mmap attribute by mmap(2)? It seems kernel issue.

It uses PCI specific fd ioctls to change the attributes.

It's the same thing as extending the mmap() attribute space, but in a
device specific way.

I think evice and platform specific mmap() attributes are basically
inevitable, at any level, embedded or desktop or whatever.  The
fact that we've hacked around the issue with device specific
interfaces like the PCI device ioctls, is no excuse to not
tackle the issue directly and come up with something usable.

