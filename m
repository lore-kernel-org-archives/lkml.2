Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0HSX5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:57:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36305 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0HSX5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:57:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Aug 2010 08:52:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] oom: fix tasklist_lock leak
Message-Id: <20100820085224.ca96c878.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100819195346.5FCA.A69D9226@jp.fujitsu.com>
References: <20100819194707.5FC4.A69D9226@jp.fujitsu.com>
	<20100819195346.5FCA.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 19:54:06 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> commit 0aad4b3124 (oom: fold __out_of_memory into out_of_memory)
> introduced tasklist_lock leak. Then it caused following obvious
> danger warings and panic.
> 
>     ================================================
>     [ BUG: lock held when returning to user space! ]
>     ------------------------------------------------
>     rsyslogd/1422 is leaving the kernel with locks still held!
>     1 lock held by rsyslogd/1422:
>      #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff810faf64>] out_of_memory+0x164/0x3f0
>     BUG: scheduling while atomic: rsyslogd/1422/0x00000002
>     INFO: lockdep is turned off.
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

