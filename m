Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab1EOWec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934091Ab1EOWeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:34:31 -0400
Message-ID: <4DD054EF.4020300@redhat.com>
Date: Sun, 15 May 2011 18:34:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com
Subject: Re: [PATCH 3/3] vmscan: implement swap token priority decay
References: <4DCD1824.1060801@jp.fujitsu.com> <4DCD1913.2090200@jp.fujitsu.com>
In-Reply-To: <4DCD1913.2090200@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 07:42 AM, KOSAKI Motohiro wrote:
> While testing for memcg aware swap token, I observed a swap token
> was often grabbed an intermittent running process (eg init, auditd)
> and they never release a token.
>
> Why? Currently, swap toke priority is only decreased at page fault
> path. Then, if the process sleep immediately after to grab swap
> token, their swap token priority never be decreased. That makes
> obviously undesired result.
>
> This patch implement very poor (and lightweight) priority decay
> mechanism. It only be affect to the above corner case and doesn't
> change swap tendency workload performance (eg multi process qsbench
> load)

Ohhh, good catch.  The original swap token algorithm did
not have this problem, and I never caught the fact that
the replacement (which is better in many ways) does...

> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
