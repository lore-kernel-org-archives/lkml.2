Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0FNHEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:04:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32984 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0FNHEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:04:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Jun 2010 16:00:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Linux/Guest unmapped page cache control
Message-Id: <20100614160021.7febbdb2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100614064955.GR5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	<20100608155146.3749.67837.sendpatchset@L34Z31A.ibm.com>
	<20100613183145.GM5191@balbir.in.ibm.com>
	<20100614092819.cb7515a5.kamezawa.hiroyu@jp.fujitsu.com>
	<20100614064955.GR5191@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 12:19:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > - Why don't you believe LRU ? And if LRU doesn't work well, should it be
> >   fixed by a knob rather than generic approach ?
> > - No side effects ?
> 
> I believe in LRU, just that the problem I am trying to solve is of
> using double the memory for caching the same data (consider kvm
> running in cache=writethrough or writeback mode, both the hypervisor
> and the guest OS maintain a page cache of the same data). As the VM's
> grow the overhead is substantial. In my runs I found upto 60%
> duplication in some cases.
> 
> 
> - Linux vm guys tend to say, "free memory is bad memory". ok, for what
>   free memory created by your patch is used ? IOW, I can't see the benefit.
>   If free memory that your patch created will be used for another page-cache,
>   it will be dropped soon by your patch itself.
> 
> Free memory is good for cases when you want to do more in the same
> system. I agree that in a bare metail environment that might be
> partially true. I don't have a problem with frequently used data being
> cached, but I am targetting a consolidated environment at the moment.
> Moreover, the administrator has control via a boot option, so it is
> non-instrusive in many ways.

It sounds that what you want is to improve performance etc. but to make it
easy sizing the system and to help admins. Right ?

>From performance perspective, I don't see any advantage to drop caches
which can be dropped easily. I just use cpus for the purpose it may no
be necessary.

Thanks,
-Kame

