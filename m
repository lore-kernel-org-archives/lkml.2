Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0EKVge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:36:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58879 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0EKVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oENYFTcOgn1AIcN5gh/zDfOWymoGAJLv1lMGYo3H0ItHYNEOsETBE4UjbNnck5El3x
         EBP9QqDzdBgWBBwoczc7yIFTb+OUUxk9Vf79LZ+PPKwk33jlikDJtaVSuQ3Wh8X8AUIE
         FGiPiHSzx4er88k+VCfWq6dQhWhwhWWSEbYwo=
Date: Tue, 11 May 2010 23:36:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, arjan@infradead.org,
       ziga.mahkovec@gmail.com
Subject: Re: [RFC] PyTimechart
Message-ID: <20100511213625.GD5422@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:10:36PM +0200, Pierre Tardy wrote:
> Hello,
> 
> PyTimechart is another implementation of two very useful tools
> available for the linux community:
> perf-timechart ( http://blog.fenrus.org/?p=5 ) and bootchart (
> http://www.bootchart.org/ )
> 
> The two tools share a common idea of making their output to SVG files.
> While it is a very good idea for small traces, the generated SVG can
> be very heavy, and turns out to be good stress tests for inkscape
> developers...
> 
> PyTimechart is a tool that parses ftrace text traces, and display them
> with the help of a very powerful dynamic plot framework, Chaco (
> http://code.enthought.com/chaco/ )
> The GUI makes the best it can to ease the browsing of huge traces.
> 
> The best is to look at those two 30s screencasts, to figure out how that work.
> 
> a look at mplayer startup:
> http://tardyp.free.fr/pytimechart/mplayer_start.mp4
> a look at ubuntu boot:
> http://tardyp.free.fr/pytimechart/boot.mp4
> 
> This tool still is in the state of a prototype, I dont know if it
> worth to continue to improve it or to implement it ideas in LTTV or
> Kernel Shark.
> It is actually very useful in its current form (
> http://elinux.org/images/0/07/Effect_of_wakeups_on_Moorestown_power.pdf
> ), and will work without recompiling the kernel of recent distros.
> 
> the source code with build instruction is located here
> http://gitorious.org/pytimechart
> 
> What do you think?


I think I've been dreaming about this several times.
I've often used perf timechart lately and I'm really frustrated by
its inherent slowness due to its huge svg files. It's barely usable
with a small trace on two cpus, and it's impossible to go further,
which is really a pity for such a powerful tool.

IMO, this GUI is exactly what we want.

If you could plug it to the perf scripting facilities, I would
be very happy to see it merged in perf tools.

Plugging to the scripting API is really easy, run:

	$ perf timechart record
	$ sudo ./perf trace -g python
	generated Python script: perf-trace.py

Now look at ./perf-trace.py, you'll find all the necessary hooks
generated with a default behaviour (displaying traces), which
you can observe by launching:

	$ perf trace -s perf-trace.py

You just need to change it to plug your app on it.

(Adding more Cc).

