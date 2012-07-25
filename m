Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab2GYRLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:11:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47861 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2GYRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:11:07 -0400
Date: Wed, 25 Jul 2012 19:11:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 16/17] perf, tool: Add dso data caching
Message-ID: <20120725171059.GF1173@somewhere.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-17-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342959280-5361-17-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 02:14:39PM +0200, Jiri Olsa wrote:
> Adding dso data caching so we don't need to open/read/close,
> each time we want dso data.
> 
> The DSO data caching affects following functions:
>   dso__data_read_offset
>   dso__data_read_addr
> 
> Each DSO read tries to find the data (based on offset) inside
> the cache. If it's not present it fills the cache from file,
> and returns the data. If it is present, data are returned
> with no file read.
> 
> Each data read is cached by reading cache page sized/aligned
> amount of DSO data. The cache page size is hardcoded to 4096.
> The cache is using RB tree with file offset as a sort key.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Nice idea.

> ---
>  tools/perf/util/symbol.c |  154 ++++++++++++++++++++++++++++++++++++++++------

There seem to be an increasing need to move dso related things
to some util/dso.c file. Just suggesting.
