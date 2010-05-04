Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab0EDIoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 04:44:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46478 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0EDIoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 04:44:19 -0400
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
In-Reply-To: <4BDFC6C0.7020009@kernel.org>
References: <1271952554-22368-1-git-send-email-tj@kernel.org>
	 <1271952554-22368-2-git-send-email-tj@kernel.org>
	 <1272893189.5605.119.camel@twins> <4BDFC06B.4020805@kernel.org>
	 <4BDFC6C0.7020009@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 10:43:40 +0200
Message-ID: <1272962620.5605.127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 09:03 +0200, Tejun Heo wrote:
> On 05/04/2010 08:36 AM, Tejun Heo wrote:
> > On 05/03/2010 03:26 PM, Peter Zijlstra wrote:
> >> On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
> >>> +static int cpu_stopper_thread(void *data)
> >>> +{
> >>> +       struct cpu_stopper *stopper = data; 
> >>
> >> BUG_ON(stopper != __get_cpu_var(cpu_stopper)); ?
> > 
> > Added.
> 
> Now that I think more about it, there's a subtle race condition with
> the above BUG_ON().  Stoppers are prepared by CPU_UP_PREPARE and
> started by CPU_ONLINE but brought down by CPU_DEAD.  IOW, they're
> allowed to run detached from their designated CPUs between CPU_DYING
> and CPU_DEAD (the reponsibility of guaranteeing target cpus's onliness
> is on the callers).  So, the above BUG_ON() might trigger spuriously
> if a cpu goes down after brought online before its cpu_stopper had a
> chance to pass through the BUG_ON() test.

Ah indeed. A well, drop it then, its not worth making a more complicated
test.
