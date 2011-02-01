Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1BAP5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:57:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1BAP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:57:10 -0500
Subject: Re: [PATCH v2 3/6] KVM-GST: KVM Steal time accounting
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4D456FF9.2010309@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-4-git-send-email-glommer@redhat.com>
	 <4D456FF9.2010309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 13:57:04 -0200
Message-ID: <1296575824.5081.17.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-30 at 16:04 +0200, Avi Kivity wrote:
> On 01/28/2011 09:52 PM, Glauber Costa wrote:
> > This patch accounts steal time time in kernel/sched.
> > I kept it from last proposal, because I still see advantages
> > in it: Doing it here will give us easier access from scheduler
> > variables such as the cpu rq. The next patch shows an example of
> > usage for it.
> >
> > Since functions like account_idle_time() can be called from
> > multiple places, not only account_process_tick(), steal time
> > grabbing is repeated in each account function separatedely.
> >
> 
> I accept that steal time is worthwhile, but do you have some way to 
> demonstrate that the implementation actually works and is beneficial?
> 
> Perhaps run two cpu-bound compute processes on one vcpu, overcommit that 
> vcpu, and see what happens to the processing rate with and without steal 
> time accounting.  I'd expect a fairer response with steal time accounting.

Avi,

There are two things here:
One of them, which is solely the accounting of steal time, (patches 1 to
4) has absolutely nothing to do with what you said. Its sole purpose is
to provide the user with information about "why is my process slow if I
am using 100 % of my cpu?")

The last patch is the only one that actually tries to rebalance cpus
according to steal time information. For that, I do have some
experiments I did here to see if it is working, will try to provide more
precise data in the next submission.


