Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0DGMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:09:26 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:62587 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab0DGMJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BbpmaL4AJsxN0HMrPwkPlRciaMua1/xVZfrvF2gXQ2j+8Yb+ELJuASwyFPFQbpZ96g
         CIoJYC//HkvWuKFrdwH6TTUMhMJKMNsKj3da6sgrJr2AGk32KqyVgljrAx1xFsgPy7SN
         QGLLHTFKnvPzL/a+Gu5AKqP4Mz2c6nqTIW2yw=
Date: Wed, 7 Apr 2010 14:09:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Store active software events in a hashlist
Message-ID: <20100407120909.GG5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com> <1270630946.5109.566.camel@twins> <20100407115251.GC5143@nowhere> <1270641405.20295.803.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270641405.20295.803.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 01:56:45PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-04-07 at 13:52 +0200, Frederic Weisbecker wrote:
> > On Wed, Apr 07, 2010 at 11:02:26AM +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> > > > +#define SWEVENT_HLIST_BITS     8
> > > > +#define SWEVENT_HLIST_SIZE     ((1 << (SWEVENT_HLIST_BITS + 1)) - 1)
> > > 
> > > That seems to result in 9 bits worth, doesn't it?
> > 
> > 
> > Oh right, I was confused, will zapp the + 1.
> > 
> 
> Also, what you're computing seems to be a mask, not a size
> 
> So with BITS = 8, you want
> SIZE = 1<<BITS = 256
> MASK = SIZE-1 = 255
> 
> right? 


Oh right... damn I suck in maths...

