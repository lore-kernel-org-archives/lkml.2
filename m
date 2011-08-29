Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1H2O0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab1H2O0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:26:14 -0400
Date: Mon, 29 Aug 2011 11:25:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] perf, tool, record: Fix the header generation for pipe
Message-ID: <20110829142547.GC27261@ghostprotocols.net>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com> <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110822145210.GA8694@jolsa.brq.redhat.com> <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110822160713.GA10134@jolsa.brq.redhat.com> <20110829132037.GB27261@ghostprotocols.net> <20110829134147.GD1918@jolsa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829134147.GD1918@jolsa.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 29, 2011 at 03:41:47PM +0200, Jiri Olsa escreveu:
> On Mon, Aug 29, 2011 at 10:20:37AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Aug 22, 2011 at 06:07:13PM +0200, Jiri Olsa escreveu:
> > > On Mon, Aug 22, 2011 at 05:51:06PM +0200, Eric Dumazet wrote:
> > > > Are you sure length cannot change between the two phases ?
> > 
> > > > /proc/kallsyms can definitely change when a module is loaded.
> > 
> > > Right, better to store it to a temp file as you suggest, so we have
> > > consistent view.. I'll prepare new patch.
> > 
> > Hi Jiri, any news here?
> > 
> > I just stumbled in this bug while testing Neil's net_dropmonitor script
> > :-\
> 
> well, I was thinking about taking files snapshot, so we dont read them
> twice and omit the reading for size.. but it'll be probably bigger
> change, I'll try to send out something by the end of the week

Yeah, at least one thing there I plan to remove, i.e. no need to copy
kallsyms when we have build ids, just stash the build id and use it
later to get the right symtab to resolve symbols.
 
> if you need workaround, the initial patch should work

Ok, thanks.

- Arnaldo
