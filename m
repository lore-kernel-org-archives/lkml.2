Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2C0PM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:12:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64228 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2C0PMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:12:55 -0400
Date: Tue, 27 Mar 2012 19:12:50 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, p4: Add format attributes
Message-ID: <20120327151250.GG11875@moon>
References: <1332859842.16159.227.camel@twins>
 <20120327145728.GE11875@moon>
 <1332860759.16159.233.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332860759.16159.233.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:05:59PM +0200, Peter Zijlstra wrote:
> > 
> > Thanks a lot, Peter! This format description is somewhat
> > new to me (I think I've missed when it was introduced first
> > time).
> 
> Yeah, its all brand-spanking new stuff.. see
> https://lkml.org/lkml/2012/1/16/146 , Jiri added a full fledged
> bison/yacc parser to perf so we can now write events like:
> 
> perf stat -e cpu/event=0xb7,umask=0x01,offcore_rsp=0x500b/
> 
> and it uses /sys/bus/event_source/devices/cpu/format/* to figure out how
> to convert that into perf_event_attr::config{,1,2} values.
> 
> So with this patch you could, on your P4, write:
> 
> perf stat -e cpu/cccr=0x1234,escr=0x4321,ht/
> 
> and it would construct the perf_event_attr::config value 0x92344321 for
> you.
> 

Ah, I see thanks for the reference, Peter!

> I've still not actually read the P4-PMU specs, so I don't know if
> there's anything more convenient we can do on P4. If there's a
> better/more useful format representation possible, don't hesitate to
> send a patch! :-)

Sure, I'll try to find some time tonight to read this brand
new stuff. And if I find something -- will send out. At moment
your patch should be more than enough ;)

	Cyrill
