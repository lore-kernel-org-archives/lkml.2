Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2EDOwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:52:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2EDOwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:52:50 -0400
Date: Fri, 4 May 2012 07:52:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, David Miller <davem@davemloft.net>,
        namhyung.kim@lge.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: Fix build failure on OpenSuse userspace
Message-ID: <20120504145245.GA9210@kroah.com>
References: <20120503215748.GA18995@kroah.com>
 <87sjfgafqj.fsf@sejong.aot.lge.com>
 <20120503.215020.954262287222794218.davem@davemloft.net>
 <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
 <CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
 <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
 <20120504024706.GA10461@kroah.com>
 <CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
 <20120504031614.GA12048@kroah.com>
 <20120504070928.GA18351@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120504070928.GA18351@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 09:09:28AM +0200, Ingo Molnar wrote:
> Does the (untested) patch below help?

No :(

> If not then please paste me the build failure output (it will 
> most likely change due to the patch), and until we fix this 
> build regression on OpenSuse userspace you can work it around 
> via:

Here's the error, it looks identical to what I previously had:

    CC perf.o
    CC util/parse-events-flex.o
<stdout>: In function ‘yy_get_next_buffer’:
<stdout>:1510:3: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
util/parse-events.l: In function ‘parse_events_lex’:
util/parse-events.l:122:1: error: ignoring return value of ‘fwrite’, declared with attribute warn_unused_result [-Werror=unused-result]
cc1: all warnings being treated as errors

>   make WERROR=0

Thanks, that works for me for now, but obviously, not a real solution :)

greg k-h
