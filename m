Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1JOTGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:06:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:41329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1JOTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:06:31 -0400
Date: Sat, 15 Oct 2011 16:06:20 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20111015190620.GA21352@ghostprotocols.net>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
 <20111015145946.GB9516@elte.hu>
 <4E99BC44.40400@gmail.com>
 <20111015170452.GD29782@elte.hu>
 <4E99C6E6.2040201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99C6E6.2040201@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 15, 2011 at 11:46:14AM -0600, David Ahern escreveu:
> 
> 
> On 10/15/2011 11:04 AM, Ingo Molnar wrote:
> > 
> > * David Ahern <dsahern@gmail.com> wrote:
> > 
> >> On 10/15/2011 08:59 AM, Ingo Molnar wrote:
> >>> Btw., i noticed another weirdness - sometimes after startup i get 
> >>> this message:
> >>>
> >>> /lib64/libc-2.14.90.so was updated, restart the long running apps that use it!                          
> >>>
> >>> but it was not updated recently:
> >>>
> >>>  earth5:~/tip/tools/perf> ll /lib64/libc-2.14.90.so
> >>>  -rwxr-xr-x 1 root root 2062920 Sep 28 15:11 /lib64/libc-2.14.90.so
> >>>  earth5:~/tip/tools/perf> date
> >>>  Sat Oct 15 16:59:04 CEST 2011
> >>>  earth5:~/tip/tools/perf> uptime
> >>>   16:59:08 up 19 days, 21:35, 11 users,  load average: 7.77, 7.48, 3.81
> >>
> >> I got the impression that comment was relative to when the 
> >> processes were started versus prelink touching it. In your case the 
> >> mod time of libc is after the uptime of the box.
> > 
> > Ok, that makes sense. Do we report this in perf report output as 
> > well?
> 
> It should. The message comes from map__load() when it detects a deleted
> mapping such as:
> 
> 7f9e8d5c7000-7f9e8d5c8000 rw-p 0000c000 fd:02 1046947
>  /lib64/libpam.so.0.82.2.#prelink#.cM3f72 (deleted)
> 
> I have removed prelink from most of my systems (managed to find one lone
> server with the above).

David,

	Can you send me a patch that clarifies this situation?

- Arnaldo
