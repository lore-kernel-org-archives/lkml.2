Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab0D3Rjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:39:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895Ab0D3Rju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cwG/m+xKwpe3+zFlCz6Tqqvg/HQJwt6IPg8Icg2+souxhxwglk6ZY5GT6v6VnGxb53
         Sgb33YieMHItNt3PZKW8J3HDrrwUMmQWf/C7nFsRLBwiecPYCTQDsjFBNTHVBlYqsvdQ
         Du2LA4SvbeHHbpqW9cWI40DZsrCG2X8l2lWg4=
Date: Fri, 30 Apr 2010 19:39:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [BUG] perf: perf trace does not work anymore
Message-ID: <20100430173948.GA5357@nowhere>
References: <v2mbd4cb8901004290528jb13ced31j7f8b0231019bbbcb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v2mbd4cb8901004290528jb13ced31j7f8b0231019bbbcb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 02:28:02PM +0200, Stephane Eranian wrote:
> Hi,
> 
> I am trying to use perf trace to dump the raw samples.
> 
> $ perf record -R noploop 5
> noploop for 5 seconds
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 0.269 MB perf.data (~11759 samples) ]
> 
> $ perf trace
>   Fatal: reading input file (size expected=3 received=-1)
> 
> Seems like trace does not understand the format of the perf.data file anymore.
> This used to work. Did you change the purpose of perf trace?


Yeah I've seen this recently. It doesn't seem to eventually impact the
output of perf trace.

In fact it seems it is looking for a field in a format file that doesn't exist
anymore, or something like that, in the /debug/tracing/events/header_page file.

Will fix, thanks.

