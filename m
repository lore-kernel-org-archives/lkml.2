Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab0FQX2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:28:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20507 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab0FQX2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:28:31 -0400
Date: Thu, 17 Jun 2010 16:25:03 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100617232502.GB7981@mail.oracle.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
	linux-kernel@vger.kernel.org, jeff@garzik.org,
	rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, johannes@sipsolutions.net, oleg@redhat.com,
	axboe@kernel.dk, Wolfram Sang <w.sang@pengutronix.de>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
 <4C17C598.7070303@kernel.org>
 <20100617161412.08337bc6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617161412.08337bc6.akpm@linux-foundation.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4C1AAF1D.00D2:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 04:14:12PM -0700, Andrew Morton wrote:
> flush_workqueue() sucks.  It's a stupid, accidental,
> internal-implementation-dependent interface.  We should deprecate it
> and try to get rid of it, migrating to the eminently more sensible
> flush_work().
> 
> I guess the first step is to add a dont-do-that checkpatch warning when
> people try to add new flush_workqueue() calls.
> 
> 165 instances tree-wide, sigh.

	What would the API be for "I want this workqueue emptied before
I shut this thing down?"  It seems silly to have everyone open-code a
loop trying to flush_work() every item in the queue.

Joel

-- 

Life's Little Instruction Book #20

	"Be forgiving of yourself and others."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
