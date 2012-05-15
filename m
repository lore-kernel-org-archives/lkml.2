Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab2EOBqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:46:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41512 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2EOBqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:46:38 -0400
Date: Mon, 14 May 2012 22:46:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, linux-kernel@vger.kernel.org,
        Lucas Meneghel Rodrigues <lmr@redhat.com>
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
Message-ID: <20120515014633.GD4254@infradead.org>
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
 <87sjf31a8c.fsf@sejong.aot.lge.com>
 <4FB1041C.1050903@gmail.com>
 <87k40e1cco.fsf@sejong.aot.lge.com>
 <4FB1B486.4020509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1B486.4020509@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 14, 2012 at 07:42:30PM -0600, David Ahern escreveu:
> On 5/14/12 7:07 PM, Namhyung Kim wrote:
> >>Something else is wrong then. I tested that command (saw your patch in
> >>the history) and it worked for me. Also, this code path does not
> >>affect perf-stat -- it touches perf-record and perf-test only.

> >Ah, right. But still wouldn't it be better changing the conditional
> >rather than disabling it unconditionally?

> I think it would be best to disable all events initially and then
> enable them when ready. It works for perf-record and perf-test just
> fine and limits the samples to what you care about.

And we need to have all this logic in a central place, the "open" method
of perf_evlist :-)

The perf_target abstraction is the way to get there, but in the process
I think we really need to have each new method with a 'perf test' entry
and in addition to that an 'autotest'* entry to test the perf builtins.

- Arnaldo

* http://autotest.github.com/
