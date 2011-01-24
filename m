Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab1AXTu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:50:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1AXTuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:50:54 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1295895083.15920.9.camel@mothafucka.localdomain>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 20:51:30 +0100
Message-ID: <1295898690.28776.472.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 16:51 -0200, Glauber Costa wrote:
> > I would really much rather see you change update_rq_clock_task() and
> > subtract your ns resolution steal time from our wall-time,
> > update_rq_clock_task() already updates the cpu_power relative to the
> > remaining time available.
> 
> But then we get into the problems we already discussed in previous
> submissions, which is, we don't really want to alter any notion of
> wallclock time. Could you list any more concrete advantages of the
> specific way you proposed? 

clock_task is the time spend on the task, by not taking steal time into
account all steal time is accounted as service to whatever task was
current when the vcpu wasn't running.

It doesn't change wall-time in the sense of gtod, only the service time
to tasks.
