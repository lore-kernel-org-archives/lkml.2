Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab0FQBvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:51:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47649 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759265Ab0FQBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-pf_exiting-check-should-take-mm-into-account.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org,
       oleg@redhat.com, balbir@in.ibm.com, rientjes@google.com
In-Reply-To: <201006081959.o58JxdZx021708@imap1.linux-foundation.org>
References: <201006081959.o58JxdZx021708@imap1.linux-foundation.org>
Message-Id: <20100617102101.FB5D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: PF_EXITING check should take mm into account
> has been added to the -mm tree.  Its filename is
>      oom-pf_exiting-check-should-take-mm-into-account.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: oom: PF_EXITING check should take mm into account
> From: Oleg Nesterov <oleg@redhat.com>
> 
> select_bad_process() checks PF_EXITING to detect the task which is going
> to release its memory, but the logic is very wrong.
> 
> 	- a single process P with the dead group leader disables
> 	  select_bad_process() completely, it will always return
> 	  ERR_PTR() while P can live forever
> 
> 	- if the PF_EXITING task has already released its ->mm
> 	  it doesn't make sense to expect it is goiing to free
> 	  more memory (except task_struct/etc)
> 
> Change the code to ignore the PF_EXITING tasks without ->mm.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



