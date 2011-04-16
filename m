Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1DPHy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 03:54:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab1DPHy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 03:54:27 -0400
Date: Sat, 16 Apr 2011 09:54:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf annotate: Add config option for additional objdump
 arguments
Message-ID: <20110416075415.GB19063@elte.hu>
References: <20110416164022.4ee0f8aa@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416164022.4ee0f8aa@kryten>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> 
> We sometimes need to pass arguments to objdump, for example to
> specify a particular machine type. In the case below I am profiling
> on POWER7 and perf annotate is unable to decode a POWER7 specific
> instruction:
> 
> c000000000008ff0:       7f 45 26 98     .long 0x7f452698
> 
> With the patch below and the following in ~/.perfconfig:
> 
> [objdump]
> 	options = -Mpower7

Hm, could we please detect the required flags automatically and pass them along 
without forcing people into twiddling their ~/.perfconfig?

I don't mind the options patch either - but please first automate it, *then* 
add this as a quick fix for similar future problems.

Thanks,

	Ingo
