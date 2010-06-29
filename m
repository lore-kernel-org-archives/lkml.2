Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0F2SFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:05:33 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:44342 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0F2SFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:05:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH -v19 00/25] Use lmb with x86
Date: Tue, 29 Jun 2010 12:06:12 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291206.13332.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 11:26:29 am Yinghai Lu wrote:
> New lmb could be used to replace early_res in x86.

Since you're fiddling in e820 anyway, can you fix places like
e820_print_map() so they use the %pR format?  I think it'd be
cleaner if e820_print_type() just returned a string pointer
rather than calling printk directly.  Then we'd only need a
single printk per region and wouldn't need the KERN_CONT junk.
