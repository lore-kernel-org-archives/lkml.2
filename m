Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2FLAEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:04:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:59691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2FLAEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151622724"
Subject: Re: [PATCH] perf report: delay sample_type checks in pipe mode
From: Tim Chen <tim.c.chen@linux.intel.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de
In-Reply-To: <4FD64BDA.7080508@gmail.com>
References: <1339444121-26236-1-git-send-email-dsahern@gmail.com>
	 <4FD64BDA.7080508@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 17:05:12 -0700
Message-ID: <1339459512.3796.235.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 13:49 -0600, David Ahern wrote:
> On 6/11/12 1:48 PM, David Ahern wrote:
> > The pipeline:
> >    perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -
> >
> > generates the warning:
> >    Selected -g but no callchain data. Did you call 'perf record' without -g?
> >
> > The problem is that the header data is not written to the pipe, so the
> > sample_type has not been available when perf_report__setup_sample_type is
> > called. For pipe mode, record dumps the sample type as part of the
> > synthesized events stream -- perf_event__synthesize_attrs(). Handle this
> > be detecting pipe mode and not doing early sanity checks on sample_type.
> 
> Slightly different fix. Tim: can you re-test?
> 
> David
> 

Works for me.

Tim

