Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0FOG7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:59:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:37726 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0FOG7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:59:47 -0400
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, tytso@mit.edu,
       Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, torvalds@linux-foundation.org,
       walken@google.com, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>
In-Reply-To: <20100614212150.4dcb1feb.akpm@linux-foundation.org>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
	 <20100614165851.6bdfe485.akpm@linux-foundation.org>
	 <20100615005619.GI6666@thunk.org>
	 <20100614185556.afdc5304.akpm@linux-foundation.org>
	 <20100615032608.GB30479@drongo>
	 <20100614212150.4dcb1feb.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 16:57:47 +1000
Message-ID: <1276585067.2552.101.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 21:21 -0700, Andrew Morton wrote:
> If that happens then the best fix is for those architectures to get
> themselves a cmpxchg64().  Unless for some reason it's simply
> unimplementable?  Worst case I guess one could use a global spinlock. 
> Second-worst-case: hashed spinlocks. 

Right, ppc32 at least can't so that would be spinlocks...

Cheers,
Ben.

