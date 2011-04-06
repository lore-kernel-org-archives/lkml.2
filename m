Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1DFFE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:04:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1DFFE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:04:28 -0400
Message-ID: <4D9BF512.6080309@redhat.com>
Date: Wed, 06 Apr 2011 01:07:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        tim.c.chen@intel.com, shaohua.li@intel.com
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 06:33 PM, Alex Shi wrote:
> commit ac53db596cc08ecb8040c removed the sched_yield task running
> time increase, so the yielded task get more opportunity to be launch
> again. That may not the caller want to be. And this also causes
> volano benchmark drop 50~80 percent performance on core2/NHM/WSM
> machines. This patch recover the sched_yield task vruntime up.
>
> Signed-off-by: alex.shi@intel.com

NACK

This was switched off by default and under
the sysctl sched_compat_yield for a reason.

Reintroducing it under that sysctl option
may be acceptable, but by default it would
be doing the wrong thing for other workloads.
