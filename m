Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0HSA53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:57:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57290 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0HSA51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:57:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NsYPJbI0DHJmNVrba+ZpRsN0mYMQQKUoOEaDbn6Tebk2lflCJt+446oUuE7U2f3VGo
         Wch1CvgWXRsbpDk7OM3Pw24Y3ILzrHmnh92dAYUkkLDaxEM0IDXukxnjLLCFuq94rPvc
         8F9h6AZHc9i1Il1+cbz/3q51jdmg/TK2Ij/p4=
Date: Thu, 19 Aug 2010 02:57:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100819005720.GB5324@nowhere>
References: <20100815225359.GA32152@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100815225359.GA32152@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 06:53:59PM -0400, Christoph Hellwig wrote:
> I'm trying to play with perf record -g, that is sampling the callchains.
> Doing this with simple workloads works fine, but when I try to do this
> with compilebench a lot of samples seem to get lost.
> 
> I'm doing the following:
> 
> perf probe --add xlog_sync
> perf record -g -e probe:xlog_sync -- ./compilebench
> 
> Trying to report it I do not get any callchains at all:
> 
> [root@virtlab106 compilebench-0.6]# perf report -g flat -n
> # Events: 9K cycles
> #
> # Overhead  Samples         Command      Shared Object     Symbol
> # ........ ..........  ............  .................  .........
> #
>     70.41%       6757  compilebench  [kernel.kallsyms]  [k] xlog_sync
>     22.61%       2170          sync  [kernel.kallsyms]  [k] xlog_sync
>      3.89%        373            sh  [kernel.kallsyms]  [k] xlog_sync
>      2.50%        240        python  [kernel.kallsyms]  [k] xlog_sync
>      0.33%         32         :3881  [kernel.kallsyms]  [k] xlog_sync
>      0.13%         12         :3971  [kernel.kallsyms]  [k] xlog_sync
>      0.11%         11         :3956  [kernel.kallsyms]  [k] xlog_sync
>      0.01%          1         :3972  [kernel.kallsyms]  [k] xlog_sync
> 
> Doing a perf report -g flat,0.0 -n shows lots of callgraph, but the
> percentag for them doesn't add up at all.


Hmm, against which tree are you running? I've just tested callchains
record on random kprobe based tracepoint and it seemed to work well
on report.

Could you send me your perf.data and also the resulting archive
after the following command: "perf archive" ?

Thanks.

