Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0LJHGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:06:35 -0500
Received: from mail.perches.com ([173.55.12.10]:2480 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab0LJHGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:06:34 -0500
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from
 mapping_unevictable()
From: Joe Perches <joe@perches.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20101210160115.C7C4.A69D9226@jp.fujitsu.com>
References: <20101207021328.569328536@goodmis.org>
	 <1291688533.16223.119.camel@gandalf.stny.rr.com>
	 <20101210160115.C7C4.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 23:06:32 -0800
Message-ID: <1291964792.24978.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 16:00 +0900, KOSAKI Motohiro wrote:
> > [ Resending to Nick's real email ]
> > 
> > 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The mapping_unevictable() has a likely() around the mapping parameter.
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
[]
> >  static inline int mapping_unevictable(struct address_space *mapping)
> >  {
> > -	if (likely(mapping))
> > +	if (mapping)
> >  		return test_bit(AS_UNEVICTABLE, &mapping->flags);
> >  	return !!mapping;
> >  }
> I think you are right.
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

It'd be better to use

	if (!mapping)
		return 0;
	return test_bit(AS_UNEVICTABLE, &mapping->flags);

to avoid the unnecessary !!

