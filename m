Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1H2NVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:21:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1H2NVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:21:00 -0400
Date: Mon, 29 Aug 2011 10:20:37 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] perf, tool, record: Fix the header generation for pipe
Message-ID: <20110829132037.GB27261@ghostprotocols.net>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com> <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110822145210.GA8694@jolsa.brq.redhat.com> <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110822160713.GA10134@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110822160713.GA10134@jolsa.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 22, 2011 at 06:07:13PM +0200, Jiri Olsa escreveu:
> On Mon, Aug 22, 2011 at 05:51:06PM +0200, Eric Dumazet wrote:
> > Le lundi 22 août 2011 à 16:52 +0200, Jiri Olsa a écrit :
> > > - fd is always file.. the descriptor, which might be pipe, is in output_fd variable
> > >   but, maybe the die call is not necessary.. this should not fail

> > > - the record_file function is called only on debugfs or procfs files:
> > > 	events/header_page
> > > 	events/header_event
> > > 	events/**/format
> > > 	printk_formats
> > > 	/proc/kallsyms

> > > so I think I need to read the whole file as in current code.

> > You read the file twice. Is it the right fix ?

> > Once to compute the length to be able to write the output header, once
> > to process the content.

> > Are you sure length cannot change between the two phases ?

> > /proc/kallsyms can definitely change when a module is loaded.

> Right, better to store it to a temp file as you suggest, so we have
> consistent view.. I'll prepare new patch.

Hi Jiri, any news here?

I just stumbled in this bug while testing Neil's net_dropmonitor script
:-\

- Arnaldo
