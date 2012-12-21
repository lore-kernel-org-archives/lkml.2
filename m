Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2LUEny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:43:54 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48102 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2LUEnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:43:45 -0500
X-AuditID: 9c930179-b7becae000000e51-15-50d3e8ff7080
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, rob@landley.net,
        mingo@redhat.com, peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 08/18] sched: consider runnable load average in move_tasks
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-9-git-send-email-alex.shi@intel.com>
	<50C80ADF.8050504@linux.vnet.ibm.com> <50C823A4.109@intel.com>
Date: Fri, 21 Dec 2012 13:43:43 +0900
In-Reply-To: <50C823A4.109@intel.com> (Alex Shi's message of "Wed, 12 Dec 2012
	14:26:44 +0800")
Message-ID: <871uekf20w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012 14:26:44 +0800, Alex Shi wrote:
> On 12/12/2012 12:41 PM, Preeti U Murthy wrote:
>> Also why can't p->se.load_avg_contrib be used directly? as a return
>> value for task_h_load_avg? since this is already updated in
>> update_task_entity_contrib and update_group_entity_contrib.
>
> No, only non task entity goes to  update_group_entity_contrib. not task
> entity.

???

But task entity goes to __update_task_entity_contrib()?


/* Compute the current contribution to load_avg by se, return any delta */
static long __update_entity_load_avg_contrib(struct sched_entity *se)
{
	long old_contrib = se->avg.load_avg_contrib;

	if (entity_is_task(se)) {
		__update_task_entity_contrib(se);
	} else {
		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
		__update_group_entity_contrib(se);
	}

	return se->avg.load_avg_contrib - old_contrib;
}


Thanks,
Namhyung
