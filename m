Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0DMFIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:08:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:59613 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0DMFIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:08:50 -0400
Subject: Re: [PATCH 07/39] lmb: Add lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BC3F317.7030702@oracle.com>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-8-git-send-email-yinghai@kernel.org>
	 <1271131543.13059.53.camel@pasglop>  <4BC3F317.7030702@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 15:07:19 +1000
Message-ID: <1271135239.13059.69.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 21:29 -0700, Yinghai wrote:
> 
> > Haven't you noticed there's already way too many functions walking
> the
> > LMBs ? :-)
> 
> x86 is using original lmb_reserve, lmb_free(), but have own version
> lmb_find_area(), and it will be dropped after
> more testing of generic version of lmb_find_area()

Do -not- add no APIs that are meant to be dropped. They never are in
practice. What I'm saying here is that the LMB code (including existing
stuff) could use some factoring in this area.

> > 
> > I think the ones doing nid alloc could/should be also rewritten to
> use
> > one single low level __lmb_find_* no ?
> 
> that nid_alloc() only has one user (sparc64).
> 
> maybe could be replaced by lmd_find_area_node(), but need to make sure
> early_node_map[] is filled at first.

How does it work today ? IE. Which ever mechanism is used that works I
don't care but we shouldn't use 2 different ones.

Cheers,
Ben.

