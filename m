Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1ALOx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:53:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35278 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1ALOxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:53:21 -0500
Subject: Re: Q: perf log mode?
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20110112144240.GA1755@nowhere>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
	 <1294841288.19601.49.camel@laptop>  <20110112144240.GA1755@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 12 Jan 2011 15:53:41 +0100
Message-ID: <1294844021.19601.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 15:42 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 12, 2011 at 03:08:08PM +0100, Peter Zijlstra wrote:
> > On Wed, 2011-01-12 at 17:06 +0300, Kirill Smelkov wrote:
> > > I'm trying to use perf together with e.g. kprobes as a tool to show what
> > > is happening with my system in "live-log" mode. The problem is, for
> > > seldom events, actual info output is largely delayed because perf reads
> > > sample data in whole pages. Could something be done with it or am I'm
> > > missing something? Here is detailed description: 
> > 
> > perf_event_attr = {
> > 	.watermark = 0,
> > 	.wakeup_events = 1,
> > };
> 
> 
> Which is perhaps something we want as a default when perf record -c 1
> and the output is the pipe mode.

No, definitely not, esp for -c1 you want large buffers because the event
can come at very high freq.

Nor does pipe mode have anything to do with it, the whole script set-up
plain stinks and should not be using pipe mode, pipe mode should only be
used to pipe data over the network and other remote profiling like
things. 
