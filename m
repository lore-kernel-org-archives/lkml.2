Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2L2Leh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 06:34:37 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:35816 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2L2Lee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 06:34:34 -0500
Date: Sat, 29 Dec 2012 11:34:34 +0000
From: Eric Wong <normalperson@yhbt.net>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas Voellmy <andreas.voellmy@yale.edu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "Junchang(Jason) Wang" <junchang.wang@yale.edu>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20121229113434.GA13336@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <20121228070652.GA6292@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228070652.GA6292@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Eric Wong <normalperson@yhbt.net> wrote:
> > I'm finding ppoll() unexpectedly stuck when waiting for POLLIN on a
> > local TCP socket.  The isolated code below can reproduces the issue
> > after many minutes (<1 hour).  It might be easier to reproduce on
> > a busy system while disk I/O is happening.
> 
> Ugh, I can't seem to reproduce this anymore...  Will try something
> else tomorrow.

The good news is I'm not imagining this...

The bad news is the issue is real and took a long time to reproduce
again.  This issue happens even without preempt, and without
tcp_low_latency on 3.7.1

While running `toosleepy', I also needed to run heavy (not loopback)
network and disk activity (several USB, SATA, and eSATA drives
simultaneously) for many hours before hitting this.

Hopefully this report is helpful in solving the issue.  Looking in at
the various pieces in net and select/poll paths, there's several
references to race conditions in the comments so this is hopefully
familiar territory to someone here...
