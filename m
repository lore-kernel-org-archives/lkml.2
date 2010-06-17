Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0FQX7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:59:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913Ab0FQX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:59:17 -0400
Date: Thu, 17 Jun 2010 16:56:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: Overview of concurrency managed workqueue
Message-Id: <20100617165655.757d221a.akpm@linux-foundation.org>
In-Reply-To: <20100617232502.GB7981@mail.oracle.com>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<20100617161412.08337bc6.akpm@linux-foundation.org>
	<20100617232502.GB7981@mail.oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 16:25:03 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> On Thu, Jun 17, 2010 at 04:14:12PM -0700, Andrew Morton wrote:
> > flush_workqueue() sucks.  It's a stupid, accidental,
> > internal-implementation-dependent interface.  We should deprecate it
> > and try to get rid of it, migrating to the eminently more sensible
> > flush_work().
> > 
> > I guess the first step is to add a dont-do-that checkpatch warning when
> > people try to add new flush_workqueue() calls.
> > 
> > 165 instances tree-wide, sigh.
> 
> 	What would the API be for "I want this workqueue emptied before
> I shut this thing down?"

Um, yeah.  flush_workqueue() is legitimate.  I was thinking of
flush_scheduled_work() - the one which operates on the keventd queue.


