Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1GEJMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:12:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:33007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1GEJMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:12:13 -0400
Subject: Re: [PATCH v5 8/9] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309793548-16714-9-git-send-email-glommer@redhat.com>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
	 <1309793548-16714-9-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 11:12:02 +0200
Message-ID: <1309857122.3282.47.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 11:32 -0400, Glauber Costa wrote:
> This patch makes update_rq_clock() aware of steal time.
> The mechanism of operation is not different from irq_time,
> and follows the same principles. This lives in a CONFIG
> option itself, and can be compiled out independently of
> the rest of steal time reporting. The effect of disabling it
> is that the scheduler will still report steal time (that cannot be
> disabled), but won't use this information for cpu power adjustments.
> 
> Everytime update_rq_clock_task() is invoked, we query information
> about how much time was stolen since last call, and feed it into
> sched_rt_avg_update().
> 
> Although steal time reporting in account_process_tick() keeps
> track of the last time we read the steal clock, in prev_steal_time,
> this patch do it independently using another field,
> prev_steal_time_rq. This is because otherwise, information about time
> accounted in update_process_tick() would never reach us in
> update_rq_clock().
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: Peter Zijlstra <peterz@infradead.org> 
