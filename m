Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0ETNny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:43:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37101 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0ETNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=daW7P4aBaz272TR8XyE3+BE5VVes0Gr9bYGPK4QWDpS+zOmr8K/l704gLzaGrxC8x7
         1zGtDpgRi2YP/KOZJd1pKKIIa/S7fwBnIBIMorCLfc7NnEXXeaW9OzTVLAn6oLiByj1w
         R7W6DRv5bVsN5wswHY57gfGIWV11cg5d3VAAo=
Date: Thu, 20 May 2010 15:43:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Use read() instead of lseek() in
	trace_event_read.c:skip()
Message-ID: <20100520134356.GA10080@nowhere>
References: <1273032130.6383.28.camel@tropicana> <tip-cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d@git.kernel.org> <AANLkTikqkbScJOVxynoOzejKnaNIucrAczgtGIDqXLCO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikqkbScJOVxynoOzejKnaNIucrAczgtGIDqXLCO@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 04:39:37PM +0300, Pekka Enberg wrote:
> On Thu, May 20, 2010 at 3:54 PM, tip-bot for Tom Zanussi
> <tzanussi@gmail.com> wrote:
> > Commit-ID:  cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
> > Gitweb:     http://git.kernel.org/tip/cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
> > Author:     Tom Zanussi <tzanussi@gmail.com>
> > AuthorDate: Tue, 4 May 2010 23:02:10 -0500
> > Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> > CommitDate: Thu, 20 May 2010 08:37:17 +0200
> >
> > perf: Use read() instead of lseek() in trace_event_read.c:skip()
> >
> > This is a small fix for a problem affecting live-mode, introduced
> > recently:
> >
> > root@tropicana:~# perf trace rwtop
> > perf trace started with Perl
> > script /root/libexec/perf-core/scripts/perl/rwtop.pl
> >
> >  Fatal: did not read header event
> >
> > commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
> > function to skip over e.g. header_page, but this doesn't work for
> > live mode.  This patch re-implements skip() to use read() instead of
> > lseek() to fix that.
> 
> Out of curiosity: why doesn't lseek() work and why can't we fix that?


Because depending on the mode we are, that may or may not work.

We have the normal mode, when the input in a regular file (perf.data)
where it works. And we have the pipe mode, where the seek fails.

