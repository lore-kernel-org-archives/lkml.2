Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1GFRlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab1GFRlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:41:10 -0400
Message-ID: <4E149E0E.30303@redhat.com>
Date: Wed, 06 Jul 2011 13:40:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 8/9] KVM-GST: adjust scheduler cpu power
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-9-git-send-email-glommer@redhat.com>
In-Reply-To: <1309793548-16714-9-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 11:32 AM, Glauber Costa wrote:
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
> accounted in update_process_tick() would never reach us in update_rq_clock().
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>
> CC: Anthony Liguori<aliguori@us.ibm.com>
> CC: Eric B Munson<emunson@mgebm.net>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
