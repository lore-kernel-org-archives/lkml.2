Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1KIQwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:52:35 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40695 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1KIQwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:52:34 -0500
Message-ID: <4EBAAFAC.90205@parallels.com>
Date: Wed, 9 Nov 2011 14:51:56 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrew Wagin <avagin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>, <pjt@google.com>,
        <fweisbec@gmail.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v2 13/14] provide a version of cpuusage statistics inside
 cpu cgroup
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-14-git-send-email-glommer@parallels.com> <CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com> <4EBA6AF7.4020509@parallels.com> <CANaxB-z0-VY=SVEjmYKXrF+i2VW3U3QCxz0yN4Wp8-qevnd4tA@mail.gmail.com>
In-Reply-To: <CANaxB-z0-VY=SVEjmYKXrF+i2VW3U3QCxz0yN4Wp8-qevnd4tA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 12:18 PM, Andrew Wagin wrote:
> And look at cfs_rq->prev_sum_exec_runtime, probably it is not used too.
> Usage of cfs_rq->sum_exec_runtime looks strange.

No, it is not.
se->sum_exec_runtime is a per-se measure. It follows the task group as 
it moves from rq to rq. cfs->rq->sum_exec_runtime (and it's rt 
counterpart) is a measurement of accumulated runtime of all tasks that 
ever passed through this rq.
