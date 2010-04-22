Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0DVN5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:57:45 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46572 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755140Ab0DVN5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:57:44 -0400
Date: Thu, 22 Apr 2010 08:57:42 -0500
From: Robin Holt <holt@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Rik van Riel <riel@redhat.com>,
       John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100422135742.GQ4920@sgi.com>
References: <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
 <20100421165934.GN16427@zorg.emea.sgi.com>
 <4BCF336B.1050706@redhat.com>
 <19407.20109.308816.104856@stoffel.org>
 <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org>
 <20100421222414.GA26241@suse.de>
 <4BCF80F2.2010906@redhat.com>
 <20100421232200.GA22877@suse.de>
 <20100422102852.72837494@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422102852.72837494@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No - to start with it would be far saner for everything involved if the
> 4096 processor minority fixed it for the moment in their arch code by
> doing something like
> 
> 	if (max_pids < PIDS_PER_CPU * num_cpus) {
> 		max_pids = ...
> 		printk(something informative)
> 	}
> 
> in their __init marked code.

I don't understand how it would be possible for the arch maintainers
to predict what a particular machine's configuration would need for
PIDS_PER_CPU.  Many of the extra pids needed on a per-cpu basis are
brought in by device drivers or subsystems.

Are you proposing a typical configuration be used for the basis or an
extreme configuration?

If your basis is the typical configuration, how would an administrator
of the extreme configuration get themselves out of the situation of
pids_max being too small without the same command line option.

If we use the extreme case, then we end up with a lot of extraneous pids,
however I don't see that as being too terrible of a situation.

Robin
