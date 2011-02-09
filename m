Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1BISW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:22:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1BISW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:22:57 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf on 2.6.38-rc4 wedges my box
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
	<4D52D31E.5010801@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 09 Feb 2011 13:22:37 -0500
In-Reply-To: <4D52D31E.5010801@gmail.com> (David Ahern's message of "Wed, 09
	Feb 2011 10:47:10 -0700")
Message-ID: <x49fwrxax02.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> Have you tried '-e cpu-clock' for S/W based profiling vs the default H/W
> profiling? Add -v to see if the fallback to S/W is happening now.

Thanks for the suggestion, David.  I tried:

# perf record -v ls
  Warning:  ... trying to fall back to cpu-clock-ticks

couldn't open /proc/-1/status
couldn't open /proc/-1/maps
[ls output]
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.008 MB perf.data (~363 samples) ]

If I explicitly set '-e cpu-clock', then the output is the same,
except that the warning is gone.  What's up with the /proc/-1/*?

Now, when running perf record -e cpu-clock on the aio-stress run,
unsurprisingly, I get the same result:

# perf record -e cpu-clock -v -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
couldn't open /proc/-1/status
couldn't open /proc/-1/maps
adding stage write
starting with write
file size 1024MB, record size 4KB, depth 32, ios per iteration 8
max io_submit 16, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
adding file /dev/sds thread 0

and there it sits.  In this case, however, I did not see the NOHZ
warnings on the console, and this time the machine is still responding
to ping, but nothing else.

Cheers,
Jeff
