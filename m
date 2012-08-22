Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab2HVSRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:17:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52353 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab2HVSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:17:01 -0400
Date: Wed, 22 Aug 2012 15:16:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Luigi Semenzato <semenzato@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
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
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: do not flush maps on COMM for perf report
Message-ID: <20120822181653.GB13623@infradead.org>
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
 <20120822072822.GA11042@gmail.com>
 <CAA25o9RJOre2mw4z7Mh94iRKcHVdby9RjLfP91far16me8_94Q@mail.gmail.com>
 <20120822162958.GA13623@infradead.org>
 <50350F2D.6030408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50350F2D.6030408@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 22, 2012 at 10:56:13AM -0600, David Ahern escreveu:
> On 8/22/12 10:29 AM, Arnaldo Carvalho de Melo wrote:
> >Adding the EXEC event, ditto. And I agree that while adding it we want
> >to do 1/2 as pre-requisite.
> 
> maps should not be flushed on a COMM event, so that was a mistake.
> Given that what new information does an EXEC event provide? Same
> process id. A COMM event is generated on an exec, so the name change
> happens. Mappings are dropped prior to that - and there is no unmap
> event. That seems to be a missing piece. Maps are added which is
> handled by MMAP events. After that why is an exec event relevant?

Please read the original discussion about it:

https://lkml.org/lkml/2012/2/13/545

- Arnaldo
