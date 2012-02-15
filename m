Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2BORaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:30:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40222 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2BORaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:30:16 -0500
Message-ID: <4F3BEB9F.2090502@gmail.com>
Date: Wed, 15 Feb 2012 10:30:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Luigi Semenzato <semenzato@chromium.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] Perf: bug fix: distinguish between rename and exec
References: <1329195360-10699-1-git-send-email-semenzato@chromium.org> <1329310113.2293.72.camel@twins> <4F3BE3F9.2010002@gmail.com> <CAA25o9QLbUiTWr6moqYxVkcvKrOCGO9qWyN6HVzo_RWXhqUq+Q@mail.gmail.com>
In-Reply-To: <CAA25o9QLbUiTWr6moqYxVkcvKrOCGO9qWyN6HVzo_RWXhqUq+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/12 10:22 AM, Luigi Semenzato wrote:
>
> Any process that makes a prctl(PR_SET_NAME) call loses its mappings,
> no matter when makes the call.  The perf records for that process look
> like this:
>
> COMM (for the initial exec)
> MMAP (the executable)
> MMAP (1st dll)
> MMAP (2nd dll)
> ...
> COMM (for the prctl)
>
> The second COMM flushes the old mappings, and all samples from then on
> cannot be classified.  This is easily reproducible with a small
> program, which I would be happy to send.

Ok, I see that now.

Thanks,
David

>
> I found this while trying to use perf with Chrome on Chrome OS.
> Chrome forks and execs all the time, and calls prctl() in the thread
> library.

