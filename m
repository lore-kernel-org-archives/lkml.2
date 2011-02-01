Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1BAQqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1BAQqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:46:31 -0500
Subject: Re: [PATCH v2 5/6] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296577168.26581.240.camel@laptop>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-6-git-send-email-glommer@redhat.com>
	 <1296473120.15234.375.camel@laptop>
	 <1296575996.5081.20.camel@mothafucka.localdomain>
	 <1296577168.26581.240.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 14:22:38 -0200
Message-ID: <1296577358.5081.23.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 17:19 +0100, Peter Zijlstra wrote:
> On Tue, 2011-02-01 at 13:59 -0200, Glauber Costa wrote:
> > 
> > Because that part is kvm-specific, and this is scheduler general.
> > It seemed cleaner to me to do it this way. But I can do it differently,
> > certainly. 
> 
> Well, any steal time clock will be hypervisor specific, but if we agree
> that anything that enables CONFIG_PARAVIRT_TIME_ACCOUNTING provides a
> u64 steal_time_clock(int cpu) function then all should be well, right?

Once the hypervisor provided the data, it can all be generic, and have
large parts of it that are generic, living in sched.c.


> The bit you have in kvm is almost that, except it assumes cpu ==
> this_cpu.
> 
> You simply cannot rely on the silly tick accounting to drive any clock,
> its archaic.

Which tick accounting? In your other e-mail , you pointed that this only
runs in touch_steal_time, which is fine, will change. But all the rest
here, that is behind the hypervisor specific vs generic code has nothing
to do with ticks at all.

> 
> 


