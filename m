Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab2FZOYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:24:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59239 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2FZOYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:24:11 -0400
Message-ID: <4FE9C606.9070007@gmail.com>
Date: Tue, 26 Jun 2012 08:24:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Rosenberg <mrosenberg@mozilla.com>
CC: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: perf report does not get along with perf record -A
References: <443195725.4576626.1340669457668.JavaMail.root@mozilla.com>
In-Reply-To: <443195725.4576626.1340669457668.JavaMail.root@mozilla.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/12 6:10 PM, Martin Rosenberg wrote:
> I'm working under the assumption that if I want to collect statistics from multiple runs of a program, I can do this by running
> perf record prog; perf record -A prog; perf record -A prog
>
> I've found that running perf record twice results in perf report hanging, and running it more than twice results in perf report first spewing a message about invalid formats, then crashing.
> A log of the session, as well as the binary, its input and perf.data can be found at:
>
> http://www.club.cc.cmu.edu/~mjrosenb/ion/perf_crash.tar.gz


Append has been broken for a long time (v2.6.36 last working version).

git bisect points to:

commit 55b44629f599a2305265ae9c77f9d9bcfd6ddc17
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Nov 30 17:49:46 2010 +0000

     perf session: Use sensible mmap size

     On 64bit we can map the whole file in one go, on 32bit we can at 
least map
     32MB and not map/unmap tiny chunks of the file.

     Base the progress bar on 1/16 of the data size.

     Preparatory patch to get rid of the malloc/memcpy/free of trace data.

     Cc: Ingo Molnar <mingo@elte.hu>
     Cc: Peter Zijlstra <peterz@infradead.org>
     Cc: Frederic Weisbecker <fweisbec@gmail.com>
     LKML-Reference: <20101130163820.213687773@linutronix.de>
     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

:040000 040000 a0d7ddfb30b562a548052b12b142b579aa888886 
dd4e368cbdf0ba24126afcc0fe42feea3b68f4a7 M	tools


The commit right before that one (d65132) dumps some errors, but at 
least does not hang -- spinning in the event processing.

David
