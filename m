Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2KSPSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:18:40 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60413 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2KSPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:18:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121119150733.GD13607@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
	<1353248997-30763-32-git-send-email-acme@infradead.org>
	<CA+5PVA6uj3f5f9Gp=7Zp8CE+0mP7zgCknqmkUX_ootzDxUXRcA@mail.gmail.com>
	<20121119150733.GD13607@infradead.org>
Date: Mon, 19 Nov 2012 10:18:37 -0500
Message-ID: <CA+5PVA7m5EWT+9eVxUDNiS2WMov+RDFogDLemhWGmChd4BmwLQ@mail.gmail.com>
Subject: Re: [PATCH 31/32] perf powerpc: Use uapi/unistd.h to fix build error
From: Josh Boyer <jwboyer@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 10:07 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Mon, Nov 19, 2012 at 08:29:09AM -0500, Josh Boyer escreveu:
>> On Sun, Nov 18, 2012 at 9:29 AM, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
>> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
>> > Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.
>>
>> This would work for powerpc, but at least s390x and ARM have the same
>> build issue.  Why would we fix this piecemeal per-arch?
>>
>> David Howells has a patch that _should_ fix it for all of them at once.
>> Is there a reason that isn't going in?
>
> David rebased his patch on top of my perf/core branch, I just tested it
> and all works as expected, so I'd say he should push that branch
> upstream as I can't just cherry pick some csets, it needs a merge that
> involves more than just tools/perf AFAIK.

OK...  is perf/core (all 32 commits) headed into 3.7?  Because the perf
build is broken in 3.7-rcX, and we're at the point where Linus gets kind
of picky about what he accepts.  So we'd need your branch and David's to
fix compile issues.  And then we'd need Xiao Guangrong's fixes for 'perf
kvm' to only build on x86.  That's quite a number of fixes we need just
to get perf to compile.  Is someone other than me keeping track of
that?

I would just like people to stop wondering when perf builds on non-x86
architectures will work.

josh
