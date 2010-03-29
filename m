Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0C2VrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:47:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:33169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0C2VrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:47:12 -0400
Subject: Re: [PATCH 20/31] lmb: Add __NOT_KEEP_LMB to put lmb code to .init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, michael@ellerman.id.au, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100329.121139.233095272.davem@davemloft.net>
References: <4BB0D34C.7060509@kernel.org>
	 <20100329.113449.174804111.davem@davemloft.net>
	 <4BB0F3F8.3090304@kernel.org>
	 <20100329.121139.233095272.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 08:44:57 +1100
Message-ID: <1269899097.7101.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 12:11 -0700, David Miller wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Mon, 29 Mar 2010 11:39:52 -0700
> 
> > On 03/29/2010 11:34 AM, David Miller wrote:
> >> From: Yinghai Lu <yinghai@kernel.org>
> >> Date: Mon, 29 Mar 2010 09:20:28 -0700
> >> 
> >>> BTW, it seems only PowerPC need to keep lmb after init stage, right ?
> >> 
> >> For now.  Sparc64 will need it at some point in the future.
> > 
> > for memory hotplug support?
> 
> Yes.

We also can use it to implement page_is_ram() which might help
get /dev/mem cachability setting right by default one day :-)

However, we only need to keep the memory list, not the reserve list.

Cheers,
Ben.


