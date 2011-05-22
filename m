Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1EVLAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:00:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1EVLAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:00:43 -0400
Date: Sun, 22 May 2011 13:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        heil@terminal-consulting.de, penberg@kernel.org, tglx@linutronix.de,
        gorcunov@gmail.com
Cc: linux-tip-commits@vger.kernel.org,
        KVM devel mailing list <kvm@vger.kernel.org>
Subject: Re: [tip:tools/kvm] kvm tools: Add conditional compilation of symbol
 resolving
Message-ID: <20110522110035.GA14865@elte.hu>
References: <tip-c474e3fec70bcacd5b24a24838c653e5a13e7b58@git.kernel.org>
 <20110522105816.GA13373@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110522105816.GA13373@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * tip-bot for Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > diff --git a/tools/perf/feature-tests.mak b/tools/kvm/config/feature-tests.mak
> > similarity index 83%
> > copy from tools/perf/feature-tests.mak
> > copy to tools/kvm/config/feature-tests.mak
> 
> Btw, now that we have feature-tests.mak it would be nice to populate the checks 
> for the various assumptions.
> 
> One i recently ran into on a new box where i tried to install tools/kvm was:
> 
> In file included from /usr/include/features.h:387:0,
>                  from /usr/include/unistd.h:26,
>                  from include/kvm/util.h:12,
>                  from bios/e820.c:5:
> /usr/include/gnu/stubs.h:7:27: fatal error: gnu/stubs-32.h: No such file or directory
> compilation terminated.
> make: *** [bios/bios-rom.bin] Error 1
> 
> that's a dependency on glibc-dev[el].

Another detail: on 64-bit hosts the dependency is on gibc-dev[el].i686, i.e. 
the 32-bit package.

Would it be simple to remove this dependency? It's not typically installed by 
default on distros and it would be nice to make most of the kvm code build by 
default almost everywhere.

Thanks,

	Ingo
