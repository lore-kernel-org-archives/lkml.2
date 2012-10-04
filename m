Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2JDRRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:17:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52510 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2JDRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:17:35 -0400
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: mbizon@freebox.fr
Cc: David Madore <david+ml@madore.org>, Francois Romieu <romieu@fr.zoreil.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <1349370573.2532.25.camel@sakura.staff.proxad.net>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
	 <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
	 <1349366521.2532.12.camel@sakura.staff.proxad.net>
	 <1349369406.16011.82.camel@edumazet-glaptop>
	 <1349370573.2532.25.camel@sakura.staff.proxad.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Oct 2012 19:17:29 +0200
Message-ID: <1349371049.16011.90.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 19:09 +0200, Maxime Bizon wrote:

> yes, on ipv6 forward path the default NET_SKB_PAD is too small, so each
> packet forwarded has its headroom expanded, it is then recycled and gets
> its original default headroom back, then it gets forwarded,
> expanded, ...

Hmm, this sounds bad (especially without recycle)

Might I assume NET_SKB_PAD is 32 on this arch ?

We might adjust NET_SKB_PAD to avoid all these memory copies...


