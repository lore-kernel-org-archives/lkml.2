Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0ESHVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:21:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49952 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0ESHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sp0QCMosf4E/0gt/Wq/TsB/wOMoQUliNH0IFbev7yPpeng/zXeZdxz3OQQxxSBlPhc
         9p90Zzh5ZTUQ0JuF+/VCXtxyA/Qo/aseDXFwiloL08hucp35MUeZ57J3c5X/Ll7iceJv
         iJjrbgrAIoRjyPhsmfAqe+3v2aUw8Cxi5xe1s=
Date: Wed, 19 May 2010 09:21:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
Message-ID: <20100519072138.GC5704@nowhere>
References: <20100518133258.000434886@chello.nl> <20100518133726.214318408@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518133726.214318408@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:33:03PM +0200, Peter Zijlstra wrote:
> perf_output_addr() will, for space allocated using PO_LINEAR, allow
> one to get a linear address for writing its data to.
> 
> Tracepoints tend to want to do this, although when there is need to
> multiplex the events it is of course possible that each event will get
> different data due to having to construct the event multiple times.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---


I'm still not sure what you mean here by this multiplexing. Is
this about per cpu multiplexing?

There is another problem. We need something like
perf_output_discard() in case the filter reject the event (which
must be filled for this check to happen).

