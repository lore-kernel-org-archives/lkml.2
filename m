Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab1FURWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:22:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61501 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1FURWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:22:06 -0400
Date: Tue, 21 Jun 2011 13:21:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 04/15] xen/trace: add multicall tracing
Message-ID: <20110621172142.GA29370@dumpdata.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
 <a0fe82ae10c0a00c31e60ffacbeec6f49eba93a5.1308607697.git.jeremy.fitzhardinge@citrix.com>
 <20110621135256.GA28229@dumpdata.com>
 <4E00D0BD.10509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E00D0BD.10509@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E00D335.012C:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:11:25AM -0700, Jeremy Fitzhardinge wrote:
> On 06/21/2011 06:52 AM, Konrad Rzeszutek Wilk wrote:
> >> +TRACE_EVENT(xen_mc_entry,
> >> +	    TP_PROTO(struct multicall_entry *mc, unsigned nargs),
> >> +	    TP_ARGS(mc, nargs),
> >> +	    TP_STRUCT__entry(
> >> +		    __field(unsigned short, op)
> >> +		    __field(unsigned short, nargs)
> >> +		    __array(unsigned long, args, 6)
> > Not 'unsigned long' for op?
> 
> I wanted to save space in the trace buffer.  I think hypercall numbers
> are all small?

OK, but then the next entry (not shown here) used 'unsigned long' for the 'op' as well.
