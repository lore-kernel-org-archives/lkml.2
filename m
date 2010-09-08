Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0IHNpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:45:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0IHNpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:45:17 -0400
Date: Wed, 8 Sep 2010 15:45:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Paul Moore <paul.moore@hp.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, arjan@infradead.org,
        davem@davemloft.net
Subject: Re: [PATCH] Remove implicit list prefetches for most cases
Message-ID: <20100908154514.7c8596ae@basil.nowhere.org>
In-Reply-To: <1283949179.4480.3.camel@flek>
References: <1283936344-19124-1-git-send-email-andi@firstfloor.org>
	<1283949179.4480.3.camel@flek>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> If prefetch() is generally considered a "Bad Thing", 

Using it unconditionally in list_for_each style operations at least is.
> 
I'm OK with just
> removing them from NetLabel; no need to rename and conditionalize.  I
> put them in the netlbl_af[4,6]list_*() routines because those routines
> were modeled after the normal list routines which had prefetches and I
> just assumed someone much smarter had found them to be a win.

Unless you have gigantic list walk bodies they are unlikely to be
on anything modern. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
