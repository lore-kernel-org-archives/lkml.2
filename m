Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab0HaVlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:41:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44257 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0HaVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jjokPgx3W9O3T9xH8GhtnOwzSuhZ9zOk05xq2dveT+K5bvrGpT5GzNgIwGjNMT5/9b
         +9tN6q2uLGBW1tgyifY+lnUAVIWutUujZ8PSLY//j8ZY+/IMYS/Vpjd7aqLUEhNlm5Ca
         W99WTOBqyjYeXOc0WjXzTyYK2vpBUYS/dSAu8=
Subject: Re: [PATCH 03/10] Use percpu stats
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008311635100.867@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	 <1281374816-904-4-git-send-email-ngupta@vflare.org>
	 <alpine.DEB.2.00.1008301114460.10316@router.home>
	 <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>
	 <1283290106.2198.26.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1008311635100.867@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 23:41:18 +0200
Message-ID: <1283290878.2198.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 août 2010 à 16:35 -0500, Christoph Lameter a écrit :
> On Tue, 31 Aug 2010, Eric Dumazet wrote:
> 
> > > Yes, this_cpu_add() seems sufficient. I can't recall why I used u64_stats_*
> > > but if it's not required for atomic access to 64-bit then why was it added to
> > > the mainline in the first place?
> >
> > Because we wanted to have fast 64bit counters, even on 32bit arches, and
> > this has litle to do with 'atomic' on one entity, but a group of
> > counters. (check drivers/net/loopback.c, lines 91-94). No lock prefix
> > used in fast path.
> >
> > We also wanted readers to read correct values, not a value being changed
> > by a writer, with inconsistent 32bit halves. SNMP applications want
> > monotonically increasing counters.
> >
> > this_cpu_add()/this_cpu_read() doesnt fit.
> >
> > Even for single counter, this_cpu_read(64bit) is not using an RMW
> > (cmpxchg8) instruction, so you can get very strange results when low
> > order 32bit wraps.
> 
> How about fixing it so that everyone benefits?
> 

IMHO, this_cpu_read() is fine as is : a _read_ operation.

Dont pretend it can be used in every context, its not true.



