Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0EODjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 23:39:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47353 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0EODjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 23:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oKdU+fEQnh7wX4ij04oHGkDdU6KQqsyWZ98eRuqEh5Ix/aLj15bAZQiIh/fa4p1GfQ
         txGHM00kWdcNFKSmMcIc2fRLTiEnBeHHEDv3U0ZSV7sUJnAlEWVHx1KAEqb4womkIDof
         FTdRnCyezB+2NnGQYHKt/AmAdBxxzCkr7iYBw=
Date: Sat, 15 May 2010 05:39:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 3/7] Revert "perf: Fix warning while reading ring
	buffer headers"
Message-ID: <20100515033933.GC8150@nowhere>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com> <1273730632-21008-4-git-send-email-imunsie@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273730632-21008-4-git-send-email-imunsie@au1.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 04:03:48PM +1000, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This reverts commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7.
>     "perf: Fix warning while reading ring buffer headers"
> 
> The reverted patch removed the processing of the header_page, skipping
> over it instead on the assumption that perf was not using any of the
> data from that header. The patch neglected to remove the header_page_
> variables which were initialised in the removed code, nor did it fix any
> code that was using those variables.
> 
> In particular, long_size was set based on one of those variables
> (header_page_size_size) to learn the size of a long from the kernel,
> which is necessary to correctly print out some of the trace information
> in some circumstances. For instance, the size of a long in a 64 bit
> kernel would differ from the size of a long in perf if it was compiled
> for a 32 bit userspace. Perf trace needs to know the size of a long in
> the kernel so that it can print out the correct value without
> truncation.



I don't understand.
In the format file we have the size of the fields beside their type name,
so why do we need this?

Thanks.

