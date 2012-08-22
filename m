Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2HVH2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:28:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58391 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2HVH2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:28:30 -0400
Date: Wed, 22 Aug 2012 09:28:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Luigi Semenzato <semenzato@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: do not flush maps on COMM for perf report
Message-ID: <20120822072822.GA11042@gmail.com>
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luigi Semenzato <semenzato@chromium.org> wrote:

> This fixes a long-standing bug caused by the lack of separate
> COMM and EXEC record types, which makes "perf report" lose
> track of symbols when a process renames itself.
> 
> With this fix (suggested by Stephane Eranian), a COMM (rename)
> no longer flushes the maps, which is the correct behavior.
> An EXEC also no longer flushes the maps, but this doesn't
> matter because as new mappings are created (for the executable
> and the libraries) the old mappings are automatically removed.
> This is not by accident: the functionality is necessary because
> DLLs can be explicitly loaded at any time with dlopen(),
> possibly on top of existing text, so "perf report" handles
> correctly the clobbering of new mappings on top of old ones.
> 
> An alternative patch (which I proposed earlier) would be to
> introduce a separate PERF_RECORD_EXEC type, but it is a much
> larger change (about 300 lines) and is not necessary.

It would be nice to add that too - we already have FORK/EXIT, 
this seems like a natural extension.

Thanks,

	Ingo
