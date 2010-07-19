Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935894Ab0GSPE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935215Ab0GSPE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:04:58 -0400
Date: Mon, 19 Jul 2010 12:04:33 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: perf can't keep up with mmap data
Message-ID: <20100719150433.GB5222@ghostprotocols.net>
References: <20100719074813.GA418@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719074813.GA418@lst.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 19, 2010 at 09:48:13AM +0200, Christoph Hellwig escreveu:
> When running current -tip perf in my 32-bit x86 kvm guest I get lots
> of messages like:
> 
> WARNING: failed to keep up with mmap data.
> 
> when starting perf top, and still quite a few everytime it refreshes the
> display.

Should be better reported, probably with a message suggesting to use:

perf top -r RTPRIO

or to reduce the sampling frequency:

perf top -F 500

to have:

   PerfTop: 287 irqs/sec  kernel:40.8%  exact:  0.0% [500Hz cycles], (all, 2 CPUs)

Instead of the default:

   PerfTop:  35 irqs/sec  kernel:25.7%  exact:  0.0% [1000Hz cycles], (all, 2 CPUs)

- Arnaldo
