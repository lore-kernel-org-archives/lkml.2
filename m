Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1JCKXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab1JCKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:22:57 -0400
Date: Mon, 3 Oct 2011 12:22:35 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Message-ID: <20111003102235.GB1838@jolsa.redhat.com>
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
 <20110929220548.GA17597@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929220548.GA17597@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 07:05:48PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 29, 2011 at 06:01:08PM +0200, Jiri Olsa escreveu:
> > The event processing relies on all events having the same sample_type.
> > 
> > This is being checked when the session is being opened read only.
> > It also needs to be checked when we do record, since events could be
> > read during processing build IDs at the end of the record command.
> > 
> > If we process events with different sample_type the processing might
> > skip some events or hang.
> > 
> > Following command hangs on my setup:
> >   ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
> >    -e LLC-loads -- date '+%F'
> > 
> > because hardware and tracepoint events have different sample type.
> > 
> > With the patch applied the record command displays
> > "Non matching sample_type" message and exits.
> 
> That is way too cryptic :-\
> 
> What is that makes the sample type not match in this case? Can we make
> it match instead?
> 
> This is something to be properly fixed by _allowing_ non matching sample
> types, the evsel/evlist abstractions are getting we close but not there
> yet, multiple files in a perf.data/ directory are needed.
> 
> Till then can you check if we can make it match or else just say that
> the mix of events is not yet supported, please collect them in different
> sessions or something along those lines?
> 
> - Arnaldo
hi,
thanks for comments..
I just was this got in the tip tree git://tesla.tglx.de/git/linux-2.6-tip

perf tools: Exit record if events have non matching sample type
commit 6f9a4869e15de8af2fd715af876bc3e6b00757a7
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Thu Sep 29 19:49:50 2011 +0200

I've read the email trail.. I'll check the sources and try to come up
with something.. ;)

thanks,
jirka
