Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1DIN2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:28:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49109 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1DIN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vn1y0Behv0VAxRoiMPVQ4ih6wmpzh6We1GyZBrBSi25+SnkBvaMBDmaCzDCmDmRe90
         66fQgj6oPRG3bjHsC9YkxT8fMGPYT4K9TxIRz7nDcuHfQ+W8DVRBzVLV3+or26lKCOyL
         CEHKYqPkEs9TXndUyE0uiH8tKnSuL9g2u5zdg=
Date: Sat, 9 Apr 2011 15:27:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Don't schedule tracepoints when exclude_kernel
 is set
Message-ID: <20110409132709.GA1799@nowhere>
References: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
 <1302354884.9086.1272.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302354884.9086.1272.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 03:14:44PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-04-08 at 22:57 +0200, Frederic Weisbecker wrote:
> > Instead of checking attr.exclude_kernel anytime a tracepoint
> > event triggers, simply don't schedule the tracepoint it that
> > attribute is set. This makes one test less in the tracing
> > path.
> 
> Meh, I'd much rather someone spend some time on finishing the below,
> which is a much bigger improvement for trace-events.

I secretely added that to my pile already :)
That's indeed something we really want.

The above is just a little thing I noticed yesterday and I wanted
to fix. Nothing more.

About that tracepoint collection, I'm not sure I like the idr though.
That thing seems to be O(log(n)), I which we can rather approach O(1)
when possible, using a hlist perhaps.
