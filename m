Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2J3Js7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:48:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41429 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab2J3Js6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:48:58 -0400
Date: Tue, 30 Oct 2012 10:48:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf tools: Speed up the perf build time by simplifying
 the perf --version string generation
Message-ID: <20121030094852.GA21705@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
 <20121030081807.GA8245@gmail.com>
 <20121030084600.GB8245@gmail.com>
 <20121030093513.GE25959@ghostprotocols.net>
 <20121030094338.GA21644@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030094338.GA21644@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Does -l work?
> 
> Alternatively, please replace:
> 
>   git tag --list "v[0-9].[0-9]*" | tail -1
> 
> with:
> 
>   git tag | tail -1 | grep -E "v[0-9].[0-9]*"
> 
> which is just as fast.

make that:

    git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*"

this will work silently even if Git is not installed.

Thanks,

	Ingo
