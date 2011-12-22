Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab1LVTcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:32:31 -0500
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:51027 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab1LVTc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:32:29 -0500
Date: Thu, 22 Dec 2011 14:32:28 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events
 parsing
In-Reply-To: <1324380648.24621.49.camel@twins>
Message-ID: <alpine.DEB.2.02.1112221426400.5097@pianoman.cluster.toy>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>  <1323963039-7602-2-git-send-email-jolsa@redhat.com>  <1324044159.18942.104.camel@twins> <1324044196.18942.105.camel@twins>  <20111220103154.GA1861@m.brq.redhat.com> <1324378070.24621.32.camel@twins>
 <1324380648.24621.49.camel@twins>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Peter Zijlstra wrote:

> 
> This would allow us to write things like:
> 
>  perf record -e cpu/event=0x34,umask=0x01,inv,cmask=2

I know this is beating a dead horse, but are you guys *really* that 
against just linking against libpfm4?

Instead of (to use your example):
    perf record -e cpu/event=0x34,umask=0x01,inv,cmask=2
Insn't
    perf record -e nhm::UNC_CBO_CACHE_LOOKUP:M:i=1:cmask=2
much nicer? 

And the code that translates that to bits for you already exists in a nice 
library form.  And it supports Pentium 4 already.

In PAPI we're finally moving to all string-based event names simply 
because trying to create cross-platform ways of specifying bits like you 
are just didn't work very well.

Vince

