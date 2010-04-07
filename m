Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0DGL4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:56:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47078 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab0DGL4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:56:48 -0400
Subject: Re: [PATCH] perf: Store active software events in a hashlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100407115251.GC5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
	 <1270630946.5109.566.camel@twins>  <20100407115251.GC5143@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 13:56:45 +0200
Message-ID: <1270641405.20295.803.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 13:52 +0200, Frederic Weisbecker wrote:
> On Wed, Apr 07, 2010 at 11:02:26AM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> > > +#define SWEVENT_HLIST_BITS     8
> > > +#define SWEVENT_HLIST_SIZE     ((1 << (SWEVENT_HLIST_BITS + 1)) - 1)
> > 
> > That seems to result in 9 bits worth, doesn't it?
> 
> 
> Oh right, I was confused, will zapp the + 1.
> 

Also, what you're computing seems to be a mask, not a size

So with BITS = 8, you want
SIZE = 1<<BITS = 256
MASK = SIZE-1 = 255

right? 

