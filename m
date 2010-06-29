Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0F2U5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:57:48 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1977 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0F2U5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:57:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/25] lmb: Print new doubled array location info
Date: Tue, 29 Jun 2010 14:58:27 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <201006291144.14469.bjorn.helgaas@hp.com> <4C2A5189.60508@kernel.org>
In-Reply-To: <4C2A5189.60508@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291458.28495.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 29, 2010 02:03:21 pm Yinghai Lu wrote:
> On 06/29/2010 10:44 AM, Bjorn Helgaas wrote:
> > On Tuesday, June 22, 2010 11:26:32 am Yinghai Lu wrote:
> >> +	if (lmb_debug)
> >> +		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
> >> +			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
> > 
> > Please print this memory range the same way we print resources, e.g.,
> > "%#010llx-%#010llx", with "addr" and "addr + new_size - 1".
> 
> ok, I will put # for 0x.
> 
> but i like to have
> 
> xxx - yyy : to include end
> [xxx, yyy - 1]
> 
> just like current e820 print out.
> and it would be more readable without too many ffff

I think it's stupid to use two different conventions for printing
address ranges.  That just makes extra mental work for people
comparing e820 ranges with %pR resources.

I don't personally care that much whether we pick the convention of
including the end (like the current e820 output) or the convention of
excluding it (like %pR and /proc/iomem do), but whatever we pick, we
should use it consistently.

To me, the fact that /proc/iomem is user-visible and excludes the end
is a pretty strong argument for adopting that convention.

And I think you should remove the extra spaces in "xxx - yyy".
There's no reason to be different when we could be consistent.

Bjorn
