Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2F1CW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab2F1CWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:22:25 -0400
Date: Wed, 27 Jun 2012 22:22:18 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: big allocation failure during tracing init.
Message-ID: <20120628022218.GA30698@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120622193650.GA20098@redhat.com>
 <1340844763.16702.54.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340844763.16702.54.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:52:43PM -0400, Steven Rostedt wrote:
 > On Fri, 2012-06-22 at 15:36 -0400, Dave Jones wrote:
 > 
 > > I guess the problem is on kernels built with CONFIG_MAXCPUS, struct trace_iterator
 > > can be pretty large due to this embedded in it..
 > > 
 > > 	struct ring_buffer_iter *buffer_iter[NR_CPUS];
 > > 
 > > Any thoughts on how to change that to a smaller dynamic data structure,
 > > without adding too much overhead to tracing ? (I'm assuming a linked-list walk
 > > for eg would be excessive?)
 > > 
 > 
 > Does this patch fix it for you?

I'm not sure what I did to trigger the allocation failure last time,
but I'll run with this for a while, and see if anything falls out.

thanks!

	Dave
