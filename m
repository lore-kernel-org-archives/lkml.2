Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1LTR4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:56:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59193 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1LTR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:56:05 -0500
Date: Tue, 20 Dec 2011 15:55:57 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Nelson Elhage <nelhage@nelhage.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: __perf_evlist__mmap: Fix errno value on failed
 map.
Message-ID: <20111220175557.GA21838@infradead.org>
References: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
 <1324301972-22740-2-git-send-email-nelhage@nelhage.com>
 <87k45sr2yd.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k45sr2yd.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 20, 2011 at 12:33:30AM +0900, Namhyung Kim escreveu:
> >  	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
> >  				      MAP_SHARED, fd, 0);
> > -	if (evlist->mmap[idx].base == MAP_FAILED)
> > +	if (evlist->mmap[idx].base == MAP_FAILED) {
> > +		evlist->mmap[idx].base = NULL;
> >  		return -1;
> > +	}
> >  
> >  	perf_evlist__add_pollfd(evlist, fd);
> >  	return 0;
> 
> Thanks for fixing this. I posted a basically same patch for this [1]
> last week, but it seems my patch doesn't get included yet (right?),
> and your patch looks bit simpler. So Arnaldo, I'm totally fine if you
> decide to take this instead of mine.

Yeah, Nelson's seems more simple, so I'm applying his and adding your
Acked-by,

Thanks,
 
> Thanks.
> Namhyung Kim
> 
> 
> [1] https://lkml.org/lkml/2011/12/12/275
