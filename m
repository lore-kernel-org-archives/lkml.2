Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab0J1A63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:58:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45540 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab0J1A61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:58:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Oct 2010 09:52:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pawan Singh <pawan@pinger.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tweaking swap algorithm under constrained memory usage
Message-Id: <20101028095258.c778a223.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTimCSGoeRHXWS2Y5=THbOkHUfY71=B6JzOeFz_=X@mail.gmail.com>
References: <AANLkTimCSGoeRHXWS2Y5=THbOkHUfY71=B6JzOeFz_=X@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 11:41:18 -0700
Pawan Singh <pawan@pinger.org> wrote:

> I have a requirement where a user space process needs to allocate 75%
> of the memory on the machine and keep it locked i.e. not swappable.
> Other processes need to share the rest of the memory. Swap is enabled.
> I was wondering what tweaks would be required so that the swapping
> alogrithms' thresholds are based on 25% of the memory rather than on
> 100% of the memory. If I leave this at default, kswapd may decide to
> swap a lot more pages than really required because 75% of pages are
> locked. I am working on 2.6.22 kernel. I can use "swappiness" factor
> and reduce it - but I wanted to know if I can alter something
> fundamental in the kernel code to make life for rest of the processes
> better.
> 
> Thanks for any suggestions.
> 

Recent kernel (2.6.28-) has splited LRUs as
  - active/inactive ANON
  - active/inactive FILE
  - LOCKED (UNEVICTABLE) ---(new)

Then, try the new kernel is a choice.

Thanks,
-Kame

