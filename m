Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2C0PGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:06:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2C0PGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:06:17 -0400
Message-ID: <1332860759.16159.233.camel@twins>
Subject: Re: [PATCH] perf, p4: Add format attributes
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 27 Mar 2012 17:05:59 +0200
In-Reply-To: <20120327145728.GE11875@moon>
References: <1332859842.16159.227.camel@twins> <20120327145728.GE11875@moon>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 18:57 +0400, Cyrill Gorcunov wrote:
> On Tue, Mar 27, 2012 at 04:50:42PM +0200, Peter Zijlstra wrote:
> > Subject: perf, p4: Add format attributes
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Tue Mar 27 16:19:25 CEST 2012
> > 
> > Steven reported his P4 not booting properly, the missing format
> > attributes cause a NULL ptr deref. Cure this by adding the missing
> > format specification.
> > 
> > I took the format description out of the comment near 
> > p4_config_pack*() and hope that comment is still relatively 
> > accurate.
> > 
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Lin Ming <ming.m.lin@intel.com>
> > Reported-by: Steven Rostedt <rostedt@goodmis.org>
> > Tested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks a lot, Peter! This format description is somewhat
> new to me (I think I've missed when it was introduced first
> time).

Yeah, its all brand-spanking new stuff.. see
https://lkml.org/lkml/2012/1/16/146 , Jiri added a full fledged
bison/yacc parser to perf so we can now write events like:

perf stat -e cpu/event=0xb7,umask=0x01,offcore_rsp=0x500b/

and it uses /sys/bus/event_source/devices/cpu/format/* to figure out how
to convert that into perf_event_attr::config{,1,2} values.

So with this patch you could, on your P4, write:

perf stat -e cpu/cccr=0x1234,escr=0x4321,ht/

and it would construct the perf_event_attr::config value 0x92344321 for
you.

I've still not actually read the P4-PMU specs, so I don't know if
there's anything more convenient we can do on P4. If there's a
better/more useful format representation possible, don't hesitate to
send a patch! :-)

> Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks!
