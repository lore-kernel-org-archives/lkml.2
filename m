Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1IYNeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 09:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab1IYNet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 09:34:49 -0400
Date: Sun, 25 Sep 2011 15:34:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] perf tools: Fix tracing info recording
Message-ID: <20110925133406.GB2702@jolsa.brq.redhat.com>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822145210.GA8694@jolsa.brq.redhat.com>
 <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822160713.GA10134@jolsa.brq.redhat.com>
 <20110829132037.GB27261@ghostprotocols.net>
 <20110829134147.GD1918@jolsa.redhat.com>
 <20110829142547.GC27261@ghostprotocols.net>
 <20110914135840.GC2719@jolsa.brq.redhat.com>
 <20110921153016.GB1811@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921153016.GB1811@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:30:24PM +0200, Frederic Weisbecker wrote:
> On Wed, Sep 14, 2011 at 03:58:40PM +0200, Jiri Olsa wrote:
> > The tracing information is part of the perf data file. It contains
> > several files from within the tracing debugfs and procs directories.
> > 
> > Beside some static header files, for each tracing event the format
> > file is added. The /proc/kallsyms file is also added.
> > 
> > The tracing data are stored with preceeding size. This is causing some
> > dificulties for pipe output, since there's no way to tell debugfs/proc
> > file size before reading it. So, for pipe output, all the debugfs files
> > were read twice. Once to get the overall size and once to store the
> > content itself. This can cause problem in case any of these file
> > changed, within the storage time.
> > 
> > Fixing this behaviour by using temp file in case of pipe output. The
> > debugfs/proc files are being read only once, ensuring the integrity of
> > the tracing data.
> > 
> > Also changing the way the event files are searched by quering specified
> > event files directly, instead of walking the events directory.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Looks good overall, but I have some comments about details:

hi,
thanks for comments,
I'll make the changes and send out new version soon

jirka
