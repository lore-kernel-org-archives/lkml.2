Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0F3J00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:26:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59722 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0F3J0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:26:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/9] oom: oom_kill_process() doesn't select kthread child
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006211313080.8367@chino.kir.corp.google.com>
References: <20100617104517.FB7D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006211313080.8367@chino.kir.corp.google.com>
Message-Id: <20100630164452.AA3D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:26:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:
> 
> > 
> > Now, select_bad_process() have PF_KTHREAD check, but oom_kill_process
> > doesn't. It mean oom_kill_process() may choose wrong task, especially,
> > when the child are using use_mm().
> > 
> 
> This type of check should be moved to badness(), it will prevent these 
> types of tasks from being selected both in select_bad_process() and 
> oom_kill_process() if the score it returns is 0.

No, process check order of select_bad_process() is certain meaningful.
Only PF_KTHREAD check can move into badness(). Okey, that's fix to
incorrect /proc/<pid>/oom_score issue.



