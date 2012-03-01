Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2CARCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:02:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34229 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab2CARCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:02:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of siddhesh.poyarekar@gmail.com designates 10.236.78.72 as permitted sender) smtp.mail=siddhesh.poyarekar@gmail.com; dkim=pass header.i=siddhesh.poyarekar@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330618302.2453.7.camel@deneb.redhat.com>
References: <1330618302.2453.7.camel@deneb.redhat.com>
Date: Thu, 1 Mar 2012 22:32:43 +0530
Message-ID: <CAAHN_R1br+QU+DhZ5rxOjjovTtjsgEAn4Yz1wE3-J9Djd-DxFw@mail.gmail.com>
Subject: Re: build failure in linux-next
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 9:41 PM, Mark Salter <msalter@redhat.com> wrote:
> In linux-next, this breaks nommu builds:
>
> commit b8665bd461ecdc561e7c95d039567d0a79208226
> Author: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
> Date:   Sat Feb 25 12:28:09 2012 +1100
>
>    procfs: mark thread stack correctly in proc/<pid>/maps
>
> I think this was merged into linux-next from the -mm tree.
>
> There are unbalanced parens in fs/proc/task_nommu.c which leads to this
> when building:
>
> fs/proc/task_nommu.c: In function 'nommu_vma_show':
> fs/proc/task_nommu.c:177:2: warning: no return statement in function returning non-void
> fs/proc/task_nommu.c: At top level:
> fs/proc/task_nommu.c:179:14: error: expected ')' before '\xa'
> fs/proc/task_nommu.c:180:2: error: expected identifier or '(' before 'return'
> fs/proc/task_nommu.c:181:1: error: expected identifier or '(' before '}' token
>

Sorry about that. My latest patch submission to procfs happens to fix this:

https://lkml.org/lkml/2012/3/1/4

Do you need a separate submission that fixes just this build failure?


-- 
Siddhesh Poyarekar
http://siddhesh.in
