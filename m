Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab1GFVPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:15:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45592 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab1GFVPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <4E031B97.2010609@jp.fujitsu.com>
References: <4E031B97.2010609@jp.fujitsu.com>
Date: Wed, 6 Jul 2011 14:14:58 -0700
X-Google-Sender-Auth: XBeG-hwDPZEjrDi8_rdXVNLj8mk
Message-ID: <CA+8MBbLg4jBmaYkVW13WReNm8nyP1p0k3CPN=pQmvwPfRKyeQA@mail.gmail.com>
Subject: Re: ia64: replace old cpumask functions with new one
From: Tony Luck <tony.luck@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/23 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> We plan to remove old obsolete cpumask functions and plan to
> change task->cpus_allowed implementation in future.
...
>  arch/ia64/kernel/smpboot.c              |   56 +++++++++++++++---------------

I get some new warnings in this file with your patch:


arch/ia64/kernel/smpboot.c:454: warning: passing argument 2 of
‘cpumask_set_cpu’ discards qualifiers from pointer target type
arch/ia64/kernel/smpboot.c:581: warning: passing argument 1 of
‘cpumask_clear’ discards qualifiers from pointer target type
arch/ia64/kernel/smpboot.c:613: warning: passing argument 2 of
‘cpumask_set_cpu’ discards qualifiers from pointer target type
arch/ia64/kernel/smpboot.c:637: warning: passing argument 2 of
‘cpumask_set_cpu’ discards qualifiers from pointer target type
arch/ia64/kernel/smpboot.c:745: warning: passing argument 2 of
‘cpumask_clear_cpu’ discards qualifiers from pointer target type

Four of the five involve "cpu_callin_mask" which is "volatile", the other is for
"cpu_present_mask" - not sure what the problem is for this one.

-Tony
