Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0EaFGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:06:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36062 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0EaFGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WXu/DDVCxf3ISu2KCeijNJEwkFsj9eyNuwQPrsAab1uKQKs34D9gsM55n8jO+gKJOp
         v1ASYT/2VzLR+F5IBDbmO/TwfTmMzfJntdTyMB+OzYmFrGSNaSGLPFJb3nTs6zPY9sqJ
         EXkuWXQpYjd1GiUVOk9sXk6OuIfl8u57uo3lc=
MIME-Version: 1.0
In-Reply-To: <20100529125136.62CA.A69D9226@jp.fujitsu.com>
References: <20100528154549.GC12035@barrios-desktop>
	<20100528164826.GJ11364@uudg.org>
	<20100529125136.62CA.A69D9226@jp.fujitsu.com>
Date: Mon, 31 May 2010 14:06:48 +0900
Message-ID: <AANLkTimg3PuUAmUUib2pdXNyEeniccLSCEvAm9jtKNji@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>, balbir@linux.vnet.ibm.com,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki.

On Sat, May 29, 2010 at 12:59 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> oom-killer: give the dying task rt priority (v3)
>>
>> Give the dying task RT priority so that it can be scheduled quickly and die,
>> freeing needed memory.
>>
>> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
>
> Almostly acceptable to me. but I have two requests,
>
> - need 1) force_sig() 2)sched_setscheduler() order as Oleg mentioned
> - don't boost priority if it's in mem_cgroup_out_of_memory()

Why do you want to not boost priority if it's path of memcontrol?

If it's path of memcontrol and CONFIG_CGROUP_MEM_RES_CTLR is enabled,
mem_cgroup_out_of_memory will select victim task in memcg.
So __oom_kill_task's target task would be in memcg, I think.

As you and memcg guys don't complain this, I would be missing something.
Could you explain it? :)

-- 
Kind regards,
Minchan Kim
