Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2HGOSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:18:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2HGOSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:18:15 -0400
Message-ID: <502123A4.8040007@gmail.com>
Date: Tue, 07 Aug 2012 08:18:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/2] perf tools: Basic bash completion support
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com> <20120807132252.GA12858@somewhere.redhat.com>
In-Reply-To: <20120807132252.GA12858@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/12 7:22 AM, Frederic Weisbecker wrote:
> On Tue, Aug 07, 2012 at 03:19:44PM +0200, Frederic Weisbecker wrote:
>> Hey,
>>
>> Basic bash completion support. Only support perf subcommands and most -e basic
>> event descriptor (no grouping).
>>
>> I just have a small issue with tracepoints because of their ":" in the middle.
>> It auto completes as long as we haven't yet reached the semicolon. Otherwise
>> we need to add a double quote in the beginning of the expression. I'm quite
>> a newbie in bash completion though, so I might find a subtelty later to solve
>> this.
>
> Tips: for testing, you need to "make install" and update the bash completion
> scripts:
>
> 	# make install
> 	$ . /etc/bash_completion
>

ANd you need to make sure the PATH hits the updated binary and not the 
default other wise you end up with:

/tmp/pbuild/perf recUnknown option: --list-cmds

  Usage: perf [--version] [--help] COMMAND [ARGS]
Unknown option: --list-cmds

It's calling /usr/bin/perf with --list-cmds, versus the perf command I 
am running (/tmp/pbuild/perf). Any way to teach the completion to use 
the perf binary that the user is running?

David
