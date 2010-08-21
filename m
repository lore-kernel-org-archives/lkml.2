Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0HUBSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 21:18:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55850 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0HUBSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 21:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aEoa/cigoIcPKiR+VNp+rXLwHkaX5rPo0lbhF+On0WUQMhL9WDwcLXrz1R/69cdzcT
         /mEEjzE8Sj+tsMnZEyh37YtSkb+3u8cwjKsT7FCcEzpOsnbiettI0XjJjhrjPGo9zvTU
         HtH+iby4jyJE+7qCkiFRAsz4JbSHSE/Ev37Ig=
Date: Sat, 21 Aug 2010 03:18:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, Zhang Rui <rui.zhang@intel.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
Message-ID: <20100821011803.GB7959@nowhere>
References: <1282118350.5181.115.camel@rui> <1282134329.1926.3918.camel@laptop> <20100818124116.GA17957@console-pimps.org> <1282188497.11858.94.camel@minggr.sh.intel.com> <20100819075410.GA25755@console-pimps.org> <1282206714.5181.552.camel@rui> <20100819083218.GB25755@console-pimps.org> <1282211085.1926.4598.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282211085.1926.4598.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 11:44:45AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-19 at 09:32 +0100, Matt Fleming wrote:
> > 
> > 
> > How big is the hardware counter? The problem comes when the process is
> > scheduled in and runs for a long time, e.g. so long that the energy
> > hardware counter wraps. This is why it's necessary to periodically
> > sample the counter.
> > 
> Long running processes aren't the only case, you could associate an
> event with a CPU.



I don't understand what you mean.



> Right, short counters (like SH when not chained) need something to
> accumulate deltas into the larger u64. You can indeed use timers for
> that, hr or otherwise, but you don't need the swcounter hrtimer
> infrastructure for that.


So what is the point in simulating a PMI using an hrtimer? It won't be
based on periods on the interesting counter but on time periods. This
is not how we want the samples. If we want timer based samples, we can
just launch a seperate software timer based event.

In the case of SH where we need to flush to avoid wraps, I understand, but
oterwise?

