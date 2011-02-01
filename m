Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BARA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:00:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab1BARA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:00:57 -0500
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1296577030.26581.236.camel@laptop>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-5-git-send-email-glommer@redhat.com>
	 <4D45649A.4090709@redhat.com>
	 <1296575618.5081.13.camel@mothafucka.localdomain>
	 <1296577030.26581.236.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 15:00:41 -0200
Message-ID: <1296579641.5081.27.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> See, that! is the problem, don't round up like that.

Yeah, I was using usecs_to_cputime(), believing this was the standard interface. By the way, one of the things that also led to better results
were just forcing it to 0 every time we had steal == 1 in the end. But
*that* was a real hack =)

> What you can do is: steal_ticks = steal_time_clock() / TICK_NSEC, or
> simply keep a steal time delta and every time it overflows
> cputime_one_jiffy insert a steal-time tick.

What do you think about keeping accounting in msec/usec resolution and
(thus allowing us to compute half a tick to user/system, other half to
steal time) only change it to cputime in the last minute?

