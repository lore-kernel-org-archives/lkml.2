Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1I1PYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:24:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:49126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1I1PYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:24:18 -0400
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Wed, 28 Sep 2011 17:23:36 +0200
In-Reply-To: <4E833993.3020608@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	  <1316816432-9237-2-git-send-email-glommer@parallels.com>
	 <1317157252.21836.3.camel@twins> <4E833993.3020608@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317223416.24040.49.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 12:13 -0300, Glauber Costa wrote:
> On 09/27/2011 06:00 PM, Peter Zijlstra wrote:
> > On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> >>   /* Must have preemption disabled for this to be meaningful. */
> >> -#define kstat_this_cpu __get_cpu_var(kstat)
> >> +#define kstat_this_cpu this_cpu_ptr(task_group_kstat(current))
> >
> > This just lost you a debug check, the former would whinge when called
> > without preemption, the new one wont. Its part of the this_cpu feature
> > set to make debugging impossible.
> 
> Why is that?
> 
> from percpu.h:
> #define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
> 
> So I don't get it.

Ah, my bad, its not actually part of the this_cpu*() api, what wonderful
mess that is.
