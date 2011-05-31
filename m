Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1EaHXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:23:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:48295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1EaHXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:23:21 -0400
Subject: Re: perf: [patch] regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, acme@redhat.com
In-Reply-To: <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
	 <1306578144.1200.1150.camel@twins>
	 <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
	 <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 09:23:13 +0200
Message-ID: <1306826593.2530.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 21:33 -0400, Vince Weaver wrote:
> the problem was the mentioned commit tried to optimize the use of 
> watermark and wakeup_watermark without taking into account that 
> wakeup_watermark is a union with wakeup_events. 

Note that wake_events isn't related to IOC_REFRESH, wake_events is how
much events to buffer in the mmap-buffer before issuing a wakeup.

IOC_REFRESH increments event_limit, which is how many events to run
before disabling yourself.

What I gather is that due to that SIGIO bug (fixed by f506b3dc0e), you
had to have both an mmap and a wakeup in order for that signal to
arrive.


