Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1CNWc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1CNWcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:32:55 -0400
Date: Mon, 14 Mar 2011 19:32:24 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf: kernel memory leak when inherit enabled
Message-ID: <20110314223224.GD9388@ghostprotocols.net>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu> <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 06:27:19PM -0400, Vince Weaver escreveu:
> On Fri, 11 Mar 2011, Vince Weaver wrote:
> > 
> > While trying to use perf events with inherit enabled to profile some 
> > multi-threaded BLAS routines (using PAPI) I ended up out-of-memorying my 
> > machine.  It turns out you can quickly leak gigabytes of kernel memory
> > that isn't freed when the process exits.
> 
> I've bisected this.  There's a whole day I'll never see again. binutils 
> 2.21 and gcc-4.5 for the lose :(
> 
> Anyway this memory leak with inherit was introduced in 
>   4fd38e4595e


commit 4fd38e4595e2f6c9d27732c042a0e16b2753049c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu May 6 17:31:38 2010 +0200

    perf: Fix exit() vs PERF_FORMAT_GROUP
    
    Both Stephane and Corey reported that PERF_FORMAT_GROUP didn't work
    as expected if the task the counters were attached to quit before
    the read() call.
    
    The cause is that we unconditionally destroy the grouping when we
    remove counters from their context. Fix this by only doing this when
    we free the counter itself.
    
    Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
    Reported-by: Stephane Eranian <eranian@google.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <1273160566.5605.404.camel@twins>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

- Arnaldo
